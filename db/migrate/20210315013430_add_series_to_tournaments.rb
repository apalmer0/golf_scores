class AddSeriesToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_reference :tournaments, :series, null: false, foreign_key: true
  end
end
