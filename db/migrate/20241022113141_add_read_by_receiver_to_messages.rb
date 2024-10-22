class AddReadByReceiverToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :read_by_receiver, :boolean, default: false
  end
end
