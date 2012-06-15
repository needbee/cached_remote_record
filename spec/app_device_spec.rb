require 'spec_helper'

describe AppDevice do

  before(:each) do
    @app = Factory(:app)
    @device = Factory(:device)
    @attr = {
      :app => @app,
      :device => @device
    }
  end

  it "should create a new instance given valid attributes" do
    AppDevice.create!(@attr)
  end
  
  it "should require an app" do
    rec = AppDevice.create(@attr.merge(:app => nil))
    rec.should_not be_valid
  end
  
  it "should require a device" do
    rec = AppDevice.create(@attr.merge(:device => nil))
    rec.should_not be_valid
  end
  
end
