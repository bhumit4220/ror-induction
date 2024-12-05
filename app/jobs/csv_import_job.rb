class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(file, table_name)
    CSV.foreach(file.path, headers: true) do |row|
      data = row.to_h
      ActiveRecord::Base.connection.execute(<<-SQL)
        INSERT INTO #{table_name} (#{data.keys.join(", ")})
        VALUES (#{data.values.map { |v| ActiveRecord::Base.connection.quote(v) }.join(", ")});
      SQL
    end
  end
end
