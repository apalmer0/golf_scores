class DropStatColumnName < ActiveRecord::Migration[6.0]
  def change
    remove_column :data_sources, :stat_column_name, :string
  end
end
