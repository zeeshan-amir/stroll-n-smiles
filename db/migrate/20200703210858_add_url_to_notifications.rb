class AddUrlToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :url, :string, null: false, default: ""
  end
end
