class CreateDeviceLines < ActiveRecord::Migration
  def change
    create_table :device_lines do |t|
      t.string :name

      t.timestamps
    end
  end
end
