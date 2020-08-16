class AddDefaultToCorrelations < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tournaments, :correlations, '{}'
  end
end
