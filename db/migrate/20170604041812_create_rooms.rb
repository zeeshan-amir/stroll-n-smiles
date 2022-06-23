class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.integer :practitioners, null: false, default: 1
      t.integer :stations, null: false, default: 1
      t.string :name, null: false
      t.text :summary, null: false
      t.string :address, null: false
      t.string :payment_methods, null: false, array: true, default: []
      t.boolean :has_lobby, null: false, default: false
      t.boolean :has_xrays, null: false, default: false
      t.boolean :has_heating, null: false, default: false
      t.boolean :has_internet, null: false, default: false
      t.decimal :price, null: false
      t.boolean :active, null: false, default: false
      t.text :open_hours, null: false
      t.text :available_procedures
      t.time :appointment_duration, null: false, default: "01:00:00"
      t.integer :search_priority, null: false, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
