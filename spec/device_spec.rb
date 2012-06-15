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

require 'spec_helper'

describe Device do

  before(:each) do
    @attr = {
      :name => 'iPhone 4'
    }
  end
  
  it 'should create a new instance given valid attributes' do
    Device.create!(@attr)
  end
  
  it 'should require a name' do
    rec = Device.create(@attr.merge(:name => ''))
    rec.should_not be_valid
  end
  
  it 'should reject names that are too long' do
    long_name = 'a' * 51
    rec = Device.create(@attr.merge(:name => long_name))
    rec.should_not be_valid
  end
  
  it 'should reject duplicate names' do
    Device.create!(@attr)
    rec = Device.create(@attr)
    rec.should_not be_valid
  end
  
  describe 'supported device code associations' do
    
    before(:each) do
      @device = Factory(:device,:name=>'iPad 2')
      @supportedDeviceCode1 = Factory(:supported_device_code, :code => 'iPad2Wifi', :device => @device)
      @supportedDeviceCode2 = Factory(:supported_device_code, :code => 'iPad23G', :device => @device)
    end
  
    it 'should have a supported device code attribute' do
      @device.should respond_to(:supported_device_codes)
    end
  
    it 'should have the right codes' do
      @device.supported_device_codes.should == [@supportedDeviceCode1,@supportedDeviceCode2]
    end
  
    it 'should destroy associated codes' do
      @device.destroy
      [@supportedDeviceCode1,@supportedDeviceCode2].each do |c|
        SupportedDeviceCode.find_by_id(c.id).should be_nil
      end
    end
    
  end
  

end
