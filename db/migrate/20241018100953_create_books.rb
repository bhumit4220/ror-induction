class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :name
      t.string :author_name
      t.string :description
      t.integer :category_id
      t.string :image
      t.timestamps
    end
  end
end
