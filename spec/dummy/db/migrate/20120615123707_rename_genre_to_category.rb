class RenameGenreToCategory < ActiveRecord::Migration
  def change
    rename_column :apps, :genre, :category
  end
end
