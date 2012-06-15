# == Schema Information
#
# Table name: device_lines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class DeviceLine < ActiveRecord::Base
  attr_accessible :name
  has_many :devices, :dependent => :destroy
  
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }
end
