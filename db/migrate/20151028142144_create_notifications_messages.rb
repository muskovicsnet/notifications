class CreateNotificationsMessages < ActiveRecord::Migration
  def change
    create_table :notifications_messages do |t|
      t.string :subject
      t.text :body
      t.integer :sender_id
      t.string :sender_type
      t.integer :recipient_id
      t.string :recipient_type
      t.integer :parent_id
      t.string :messagetype

      t.timestamps null: false
    end

    add_index :notifications_messages, [:sender_id, :sender_type]
    add_index :notifications_messages, [:recipient_id, :recipient_type]
    add_index :notifications_messages, :messagetype
  end
end
