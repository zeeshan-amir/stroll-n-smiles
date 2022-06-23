class CreateOpenHoursWeekDays < ActiveRecord::Migration[6.0]
  def change
    create_table :open_hours_week_days do |t|
      t.time :open, null: false
      t.time :close, null: false
      t.integer :week_day, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
