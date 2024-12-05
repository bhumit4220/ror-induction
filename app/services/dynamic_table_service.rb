require 'csv'

class DynamicTableService
  def initialize(csv_path, table_name)
    @csv_path = csv_path
    @table_name = table_name
  end

  def process_csv
    csv = CSV.read(@csv_path, headers: true)
    return if csv.empty?

    headers = csv.headers
    create_table
    add_missing_columns(headers)

    batch_insert_data(csv)
  end

  def create_table
    return if table_exists?

    ActiveRecord::Base.connection.create_table(@table_name) 
  end

  private

  def table_exists?
    ActiveRecord::Base.connection.table_exists?(@table_name)
  end

  def add_missing_columns(headers)
    existing_columns = ActiveRecord::Base.connection.columns(@table_name).map(&:name)
    headers << "created_at"
    headers << "updated_at"
    headers.each do |header|
      next if existing_columns.include?(header)

      ActiveRecord::Base.connection.add_column(@table_name, header, :string)
    end
  end

  def batch_insert_data(csv)
    batch_size = 10000
    batch = []
  
    csv.each_with_index do |row, index|
      # Add created_at and updated_at timestamps to each record
      record = row.to_h.merge(
        'created_at' => Time.current,
        'updated_at' => Time.current
      )
      batch << record
  
      if batch.size >= batch_size || index == csv.size - 1
        insert_batch(batch)
        batch.clear
      end
    end
  end
  
  def insert_batch(batch)
    columns = batch.first.keys.map { |col| ActiveRecord::Base.connection.quote_column_name(col) }
    values = batch.map do |row|
      row.values.map { |value| ActiveRecord::Base.connection.quote(value) }.join(", ")
    end
  
    query = "INSERT INTO #{@table_name} (#{columns.join(', ')}) VALUES #{values.map { |v| "(#{v})" }.join(', ')}"
    ActiveRecord::Base.connection.execute(query)
  rescue => e
    Rails.logger.error "Error inserting batch: #{e.message}"
  end
  
end
