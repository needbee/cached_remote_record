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

require 'spec_helper'

describe SupportedDeviceCode do

  before(:each) do
    @attr = {
      :code => 'iPhone4'
    }
  end
  
  it 'should create a new instance given valid attributes' do
    SupportedDeviceCode.create!(@attr)
  end
  
  it 'should require a name' do
    rec = SupportedDeviceCode.create(@attr.merge(:code => ''))
    rec.should_not be_valid
  end
  
  it 'should reject names that are too long' do
    long_name = 'a' * 51
    rec = SupportedDeviceCode.create(@attr.merge(:code => long_name))
    rec.should_not be_valid
  end
  
end
