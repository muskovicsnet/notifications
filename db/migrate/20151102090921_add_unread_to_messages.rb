class AddUnreadToMessages < ActiveRecord::Migration
  def change
    add_column :notifications_messages, :unread, :boolean, default: true
  end
end
