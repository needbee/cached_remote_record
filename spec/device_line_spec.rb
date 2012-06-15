# == Schema Information
#
# Table name: device_lines
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe DeviceLine do
  
  before(:each) do
    @attr = {
      :name => 'iPhone'
    }
  end
  
  it 'should create a new instance given valid attributes' do
    DeviceLine.create!(@attr)
  end
  
  it 'should require a name' do
    rec = DeviceLine.create(@attr.merge(:name => ''))
    rec.should_not be_valid
  end
  
  it 'should reject names that are too long' do
    long_name = 'a' * 51
    rec = DeviceLine.create(@attr.merge(:name => long_name))
    rec.should_not be_valid
  end
  
  it 'should reject duplicate names' do
    DeviceLine.create!(@attr)
    rec = DeviceLine.create(@attr)
    rec.should_not be_valid
  end
  
  describe 'device associations' do
    
    before(:each) do
      @device_line = Factory(:device_line)
      @device1 = Factory(:device, :name => 'a', :device_line => @device_line)
      @device2 = Factory(:device, :name => 'b', :device_line => @device_line)
    end
  
    it 'should have a devices attribute' do
      @device_line.should respond_to(:devices)
    end
  
    it 'should have the right devices' do
      @device_line.devices.should == [@device1,@device2]
    end
  
    it 'should destroy associated devices' do
      @device_line.destroy
      [@device1,@device2].each do |d|
        Device.find_by_id(d.id).should be_nil
      end
    end
    
  end
  
end
