class AddApprovedToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :approved, :boolean, null: false, default: false
  end
end
