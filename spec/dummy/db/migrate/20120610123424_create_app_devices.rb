class CreateAppDevices < ActiveRecord::Migration
  def change
    create_table :app_devices do |t|
      t.integer :app_id
      t.integer :device_id

      t.timestamps
    end
  end
end
