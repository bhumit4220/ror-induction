class AddAuthorIdToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :author_id, :integer
    remove_column :books, :author_name
  end
end
