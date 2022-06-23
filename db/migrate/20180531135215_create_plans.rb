class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.decimal :price_monthly, null: false, default: 0
      t.decimal :price_semiannual, null: false, default: 0
      t.decimal :price_annual, null: false, default: 0
    end
  end
end
