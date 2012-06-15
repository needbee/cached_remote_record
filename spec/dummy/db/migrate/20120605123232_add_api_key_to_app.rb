class AddApiKeyToApp < ActiveRecord::Migration
  def change
    add_column :apps, :api_key, :string
  end
end
