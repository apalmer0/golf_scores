class DropGolfers < ActiveRecord::Migration[6.0]
  def change
    drop_table :golfers
  end
end
