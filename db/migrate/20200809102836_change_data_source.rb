class ChangeDataSource < ActiveRecord::Migration[6.0]
  def change
    remove_column :data_sources, :last_fetched, :datetime
    remove_column :data_sources, :destination_column_names, :string
    remove_column :data_sources, :data_types, :string
    remove_column :data_sources, :year, :integer
    remove_column :data_sources, :url, :string
    remove_column :data_sources, :table_location, :string
    remove_column :data_sources, :source, :integer
    remove_column :data_sources, :golfer_column_name, :string
    remove_column :data_sources, :source_column_names, :string, array: true, default: []

    add_column :data_sources, :pga_id, :string
    add_column :data_sources, :stat_column_name, :string
  end
end
