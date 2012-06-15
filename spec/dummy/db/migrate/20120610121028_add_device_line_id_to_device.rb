class AddDeviceLineIdToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :device_line_id, :integer
  end
end
