class RemoveAppStoreId < ActiveRecord::Migration
  def up
    remove_column :apps, :app_store_id
  end

  def down
    add_column :apps, :app_store_id, :string
  end
end
