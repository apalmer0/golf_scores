class AddCorrelationToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :tournaments, :correlations, :json
  end
end
