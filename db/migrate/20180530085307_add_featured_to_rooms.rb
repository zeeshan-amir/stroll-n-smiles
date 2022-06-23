class AddFeaturedToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :featured, :boolean, null: false, default: false
    add_column :rooms, :featured_order, :integer, null: false, default: 0
  end
end
