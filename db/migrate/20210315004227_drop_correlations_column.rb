class DropCorrelationsColumn < ActiveRecord::Migration[6.0]
  def up
    remove_column :tournaments, :correlations
  end

  def down
    add_column :tournaments, :correlations, :json
  end
end
