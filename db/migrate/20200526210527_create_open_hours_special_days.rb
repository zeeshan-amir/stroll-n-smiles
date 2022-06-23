class CreateOpenHoursSpecialDays < ActiveRecord::Migration[6.0]
  def change
    create_table :open_hours_special_days do |t|
      t.time :open, null: true
      t.time :close, null: true
      t.integer :day, null: false
      t.integer :month, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
