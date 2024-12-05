class CreateDynamicTables < ActiveRecord::Migration[6.0]
  def change
    create_table :dynamic_tables do |t|
      t.string :name
      t.jsonb :columns
      t.timestamps
    end

    create_table :csv_uploads do |t|
      t.string :file
      t.timestamps
    end
  end
end
