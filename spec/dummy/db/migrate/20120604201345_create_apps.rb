class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.datetime :date_updated
      t.string :app_store_id
      t.string :name
      t.string :version
      t.decimal :price
      t.integer :file_size_bytes
      t.datetime :release_date
      t.string :genre
      t.string :company_name
      t.text :description
      t.text :release_notes
      t.string :company_url
      t.string :artwork_url
      t.string :itunes_link

      t.timestamps
    end
  end
end
