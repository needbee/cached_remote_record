class CreateSupportedDeviceCodes < ActiveRecord::Migration
  def change
    create_table :supported_device_codes do |t|
      t.string :code

      t.timestamps
    end
  end
end
