class DropDataPoint < ActiveRecord::Migration[6.0]
  def change
    drop_table :data_points
  end
end
