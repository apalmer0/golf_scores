class CreateScrapeLoggers < ActiveRecord::Migration[6.0]
  def change
    create_table :scrape_loggers do |t|
      t.datetime :run_at, null: false
      t.integer :role

      t.timestamps
    end
  end
end
