class DropPgaIdFromTournaments < ActiveRecord::Migration[6.0]
  def up
    remove_column :tournaments, :pga_id
  end

  def down
    add_column :tournaments, :pga_id
  end
end
