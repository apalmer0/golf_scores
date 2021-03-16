class CreateCorrelations < ActiveRecord::Migration[6.0]
  def change
    create_table :correlations do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :data_source, null: false, foreign_key: true
      t.float :coefficient, null: false

      t.timestamps
    end
  end
end
