class CreateDataPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :data_points do |t|
      t.references :golfer, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
      t.string :value
      t.integer :rank
      t.references :data_source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
