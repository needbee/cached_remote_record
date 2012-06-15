class AddDeviceIdToSupportedDeviceCode < ActiveRecord::Migration
  def change
    add_column :supported_device_codes, :device_id, :integer
  end
end
