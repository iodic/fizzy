class AddEstimateHoursToCards < ActiveRecord::Migration[8.2]
  def change
    add_column :cards, :estimate_hours, :decimal, precision: 6, scale: 2
    add_index :cards, :estimate_hours
  end
end
