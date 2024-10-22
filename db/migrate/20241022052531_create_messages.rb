class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_foreign_key :messages, :users, column: :sender_id
    add_foreign_key :messages, :users, column: :receiver_id
    add_index :messages, [:sender_id, :receiver_id]
  end
end
