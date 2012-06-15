class RemoveDateUpdatedFromApp < ActiveRecord::Migration
  def up
    remove_column :apps, :date_updated
  end

  def down
    add_column :apps, :date_updated, :datetime
  end
end
