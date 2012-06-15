class AddItunesRatingToApp < ActiveRecord::Migration
  def change
    add_column :apps, :itunes_rating, :integer
  end
end
