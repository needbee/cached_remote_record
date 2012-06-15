class RenameArtworkUrlToIconUrl < ActiveRecord::Migration
  def change
    rename_column :apps, :artwork_url, :icon_url
  end
end
