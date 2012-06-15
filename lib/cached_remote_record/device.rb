# == Schema Information
#
# Table name: devices
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  device_line_id :integer
#

class Device < ActiveRecord::Base
  attr_accessible :name, :device_line_id, :device_line
  belongs_to :device_line
  has_many :supported_device_codes, :dependent => :destroy
  has_many :app_devices
  has_many :apps, :through => :app_devices
  
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }
end
