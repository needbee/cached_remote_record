# == Schema Information
#
# Table name: supported_device_codes
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  device_id  :integer
#

class SupportedDeviceCode < ActiveRecord::Base
  attr_accessible :code, :device_id, :device
  belongs_to :device
  
  validates :code,  :presence => true,
                    :length => { :maximum => 50 }
end
