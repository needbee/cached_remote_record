# == Schema Information
#
# Table name: apps
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  version         :string(255)
#  price           :decimal(, )
#  file_size_bytes :integer
#  release_date    :datetime
#  category        :string(255)
#  company_name    :string(255)
#  description     :text
#  release_notes   :text
#  company_url     :string(255)
#  icon_url        :string(255)
#  itunes_link     :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  api_key         :string(255)
#  itunes_rating   :integer
#

require 'spec_helper'

describe App do

  before(:each) do
    @app_id = '412347169'
    @app_query = 'typelink'
    @app_correct_name = 'TypeLink'
    @app_correct_version = '1.0.9'
    @app_incorrect_name = 'Foo'
    @app_incorrect_version = '0.0.1'
    
    content = <<END
    {
     "resultCount":1,
     "results": [
    {"kind":"software", "features":["iosUniversal"], "supportedDevices":["all"], "isGameCenterEnabled":false, "artistViewUrl":"http://itunes.apple.com/us/artist/josh-justice/id412347172?uo=4", "artworkUrl60":"http://a3.mzstatic.com/us/r1000/087/Purple/64/11/7c/mzi.vbrpetdo.png", 
    "screenshotUrls":["http://a2.mzstatic.com/us/r1000/085/Purple/dd/be/3e/mzl.frfwtwex.png", "http://a5.mzstatic.com/us/r1000/075/Purple/a1/8c/8a/mzl.qwxitnvg.png", "http://a5.mzstatic.com/us/r1000/097/Purple/a5/34/b1/mzl.yfwuhqmo.png"], 
    "ipadScreenshotUrls":["http://a4.mzstatic.com/us/r1000/118/Purple/4d/39/bf/mzl.yhxqiguh.1024x1024-65.jpg", "http://a3.mzstatic.com/us/r1000/112/Purple/bf/b4/b2/mzl.wgwtfzxv.1024x1024-65.jpg", "http://a4.mzstatic.com/us/r1000/114/Purple/76/01/22/mzl.jasxnhos.1024x1024-65.jpg", "http://a4.mzstatic.com/us/r1000/097/Purple/d7/2a/6c/mzl.lnwjlddo.1024x1024-65.jpg"], "artworkUrl512":"http://a3.mzstatic.com/us/r1000/081/Purple/80/75/01/mzl.xeymszyc.png", "artistId":412347172, "artistName":"Josh Justice", "price":0.00, "version":"1.0.9", 
    "description":"hello, world", "genreIds":["6007"], "releaseDate":"2011-01-01T03:23:17Z", "sellerName":"Joshua Justice", "currency":"USD", "genres":["Productivity"], "bundleId":"net.typelink.typelinkios", "trackId":412347169, "trackName":"TypeLink", "primaryGenreName":"Productivity", "primaryGenreId":6007, 
    "releaseNotes":"hello, world", "wrapperType":"software", "trackCensoredName":"TypeLink", "trackViewUrl":"http://itunes.apple.com/us/app/typelink/id412347169?mt=8&uo=4", "contentAdvisoryRating":"4+", "artworkUrl100":"http://a3.mzstatic.com/us/r1000/081/Purple/80/75/01/mzl.xeymszyc.png", "languageCodesISO2A":["EN"], "fileSizeBytes":"512175", "sellerUrl":"http://typelink.net", "averageUserRatingForCurrentVersion":5.0, "userRatingCountForCurrentVersion":1, "trackContentRating":"4+", "averageUserRating":4.0, "userRatingCount":27}]
    }
END

    @search_url = 'http://itunes.apple.com/search?entity=software&term=typelink'
    @find_url = 'http://itunes.apple.com/lookup?id=412347169'

    stub_request(:get, @search_url)
      .to_return(:body => content )
    stub_request(:get, @find_url)
      .to_return(:body => content )

  end
  
  describe 'fields' do

    before(:each) do
      @attr = {
        :name             => 'TypeLink',
        :version          => '1.0.9',
        :price            => 0.99,
        :file_size_bytes  => 512175,
        :release_date     => '2011-01-01T03:23:17Z',
        :category         => 'Productivity',
        :company_name     => 'NeedBee',
        :description      => 'You type, it links!',
        :release_notes    => 'Fixed bugs',
        :company_url      => 'http://need-bee.com',
        :icon_url         => 'http://a3.mzstatic.com/us/r1000/087/Purple/64/11/7c/mzi.vbrpetdo.png',
        :itunes_link      => 'http://itunes.apple.com/us/app/typelink/id412347169?mt=8&uo=4',
        :api_key          => '412347169',
        :itunes_rating    => 4
      }
    end

    it "should create a new instance given valid attributes" do
      App.create!(@attr)
    end

    it 'should reject duplicate api keys' do
      App.create!(@attr)
      rec = App.create(@attr)
      rec.should_not be_valid
    end

    it "should require an api key" do
      rec = App.create(@attr.merge(:api_key => nil))
      rec.should_not be_valid
    end

    it "should require a name" do
      rec = App.create(@attr.merge(:name => nil))
      rec.should_not be_valid
    end

    it "should require a version" do
      rec = App.create(@attr.merge(:version => nil))
      rec.should_not be_valid
    end

    it "should require a price" do
      rec = App.create(@attr.merge(:price => nil))
      rec.should_not be_valid
    end

    it "should not require a file size" do
      rec = App.create(@attr.merge(:file_size_bytes => nil))
      rec.should be_valid
    end

    it "should not require a release date" do
      rec = App.create(@attr.merge(:release_date => nil))
      rec.should be_valid
    end

    it "should require a category" do
      rec = App.create(@attr.merge(:category => nil))
      rec.should_not be_valid
    end

    it "should not require a company name" do
      rec = App.create(@attr.merge(:company_name => nil))
      rec.should be_valid
    end

    it "should not require a description" do
      rec = App.create(@attr.merge(:description => nil))
      rec.should be_valid
    end

    it "should not require release notes" do
      rec = App.create(@attr.merge(:release_notes => nil))
      rec.should be_valid
    end

    it "should not require a company url" do
      rec = App.create(@attr.merge(:company_url => nil))
      rec.should be_valid
    end

    it "should require an icon url" do
      rec = App.create(@attr.merge(:icon_url => nil))
      rec.should_not be_valid
    end

    it "should require an itunes link" do
      rec = App.create(@attr.merge(:itunes_link => nil))
      rec.should_not be_valid
    end

    it "should require an itunes rating" do
      rec = App.create(@attr.merge(:itunes_rating => nil))
      rec.should_not be_valid
    end

  end
  
  describe 'relationships' do
    
    before(:each) do
      iphone    = Factory(:device_line, :name => 'iPhone')
      ipad      = Factory(:device_line, :name => 'iPad')
      
      iphone3gs = Factory(:device, :name => 'iPhone 3GS', :device_line => iphone)
      iphone4   = Factory(:device, :name => 'iPhone 4', :device_line => iphone)
      iphone4s  = Factory(:device, :name => 'iPhone 4S', :device_line => iphone)
      ipad1     = Factory(:device, :name => 'iPad', :device_line => ipad)
      ipad2     = Factory(:device, :name => 'iPad 2', :device_line => ipad)
      ipad3g    = Factory(:device, :name => 'iPad 3 Gen', :device_line => ipad)
      
      Factory(:supported_device_code, :code => 'iPhone-3GS', :device => iphone3gs)
      Factory(:supported_device_code, :code => 'iPhone4', :device => iphone4)
      Factory(:supported_device_code, :code => 'iPhone4', :device => iphone4s)
      Factory(:supported_device_code, :code => 'iPadWiFi', :device => ipad1)
      Factory(:supported_device_code, :code => 'iPad3G', :device => ipad1)
      Factory(:supported_device_code, :code => 'iPad2WiFi', :device => ipad2)
      Factory(:supported_device_code, :code => 'iPad23G', :device => ipad2)
      Factory(:supported_device_code, :code => 'iPad2WiFi', :device => ipad3g)
      Factory(:supported_device_code, :code => 'iPad23G', :device => ipad3g)
    end
    
    describe 'devices specified' do
    
      before(:each) do
        content = <<END
  {
   "resultCount":1,
   "results": [
  {"kind":"software", "features":["iosUniversal"], "supportedDevices":["iPhone4","iPad2Wifi","iPad23G"], "isGameCenterEnabled":false, "artistViewUrl":"http://itunes.apple.com/us/artist/josh-justice/id412347172?uo=4", "artworkUrl60":"http://a3.mzstatic.com/us/r1000/087/Purple/64/11/7c/mzi.vbrpetdo.png", 
  "screenshotUrls":["http://a2.mzstatic.com/us/r1000/085/Purple/dd/be/3e/mzl.frfwtwex.png", "http://a5.mzstatic.com/us/r1000/075/Purple/a1/8c/8a/mzl.qwxitnvg.png", "http://a5.mzstatic.com/us/r1000/097/Purple/a5/34/b1/mzl.yfwuhqmo.png"], 
  "ipadScreenshotUrls":["http://a4.mzstatic.com/us/r1000/118/Purple/4d/39/bf/mzl.yhxqiguh.1024x1024-65.jpg", "http://a3.mzstatic.com/us/r1000/112/Purple/bf/b4/b2/mzl.wgwtfzxv.1024x1024-65.jpg", "http://a4.mzstatic.com/us/r1000/114/Purple/76/01/22/mzl.jasxnhos.1024x1024-65.jpg", "http://a4.mzstatic.com/us/r1000/097/Purple/d7/2a/6c/mzl.lnwjlddo.1024x1024-65.jpg"], "artworkUrl512":"http://a3.mzstatic.com/us/r1000/081/Purple/80/75/01/mzl.xeymszyc.png", "artistId":412347172, "artistName":"Josh Justice", "price":0.00, "version":"1.0.9", 
  "description":"hello, world", "genreIds":["6007"], "releaseDate":"2011-01-01T03:23:17Z", "sellerName":"Joshua Justice", "currency":"USD", "genres":["Productivity"], "bundleId":"net.typelink.typelinkios", "trackId":412347169, "trackName":"TypeLink", "primaryGenreName":"Productivity", "primaryGenreId":6007, 
  "releaseNotes":"hello, world", "wrapperType":"software", "trackCensoredName":"TypeLink", "trackViewUrl":"http://itunes.apple.com/us/app/typelink/id412347169?mt=8&uo=4", "contentAdvisoryRating":"4+", "artworkUrl100":"http://a3.mzstatic.com/us/r1000/081/Purple/80/75/01/mzl.xeymszyc.png", "languageCodesISO2A":["EN"], "fileSizeBytes":"512175", "sellerUrl":"http://typelink.net", "averageUserRatingForCurrentVersion":5.0, "userRatingCountForCurrentVersion":1, "trackContentRating":"4+", "averageUserRating":4.0, "userRatingCount":27}]
  }
END

        all_search_url = 'http://itunes.apple.com/search?entity=software&term=devices'
        stub_request(:get, all_search_url)
          .to_return(:body => content )

      end
    
      it 'should have the correct devices' do
        result = App.search_api('devices')
        result.count.should == 1
        app = result[0]
        app.devices.count.should == 4
        # app.devices.each do |d| puts d.name end
        app.devices[0].name.should == 'iPhone 4'
        app.devices[1].name.should == 'iPhone 4S'
        app.devices[2].name.should == 'iPad 2'
        app.devices[3].name.should == 'iPad 3 Gen'
      end
      
      it 'should overwrite old devices' do
        # set bad device data
        result = App.search_api('devices')
        result[0].update_attributes(
          :devices => [Device.first],
          :version => '0.0.1'
        )
        app = App.first
        app.version.should == '0.0.1'
        app.devices.count.should == 1
        
        result = App.search_api('devices')
        result.count.should == 1
        app = result[0]
        app.devices.count.should == 4
        app.devices[0].name.should == 'iPhone 4'
        app.devices[1].name.should == 'iPhone 4S'
        app.devices[2].name.should == 'iPad 2'
        app.devices[3].name.should == 'iPad 3 Gen'
      end
      
    end
    
    describe 'all specified' do
      
      it 'should have all devices' do
        result = App.search_api(@app_query)
        result.count.should == 1
        app = result[0]
        app.devices.count.should == 6
        # app.devices.each do |d| puts d.name end
        app.devices[0].name.should == 'iPhone 3GS'
        app.devices[1].name.should == 'iPhone 4'
        app.devices[2].name.should == 'iPhone 4S'
        app.devices[3].name.should == 'iPad'
        app.devices[4].name.should == 'iPad 2'
        app.devices[5].name.should == 'iPad 3 Gen'
      end
      
      it 'should overwrite old devices' do
        # set bad device data
        result = App.search_api(@app_query)
        result[0].update_attributes(
          :devices => [Device.first],
          :version => '0.0.1'
        )
        app = App.first
        app.version.should == '0.0.1'
        app.devices.count.should == 1
        
        result = App.search_api(@app_query)
        result.count.should == 1
        app = result[0]
        app.devices.count.should == 6
        # app.devices.each do |d| puts d.name end
        app.devices[0].name.should == 'iPhone 3GS'
        app.devices[1].name.should == 'iPhone 4'
        app.devices[2].name.should == 'iPhone 4S'
        app.devices[3].name.should == 'iPad'
        app.devices[4].name.should == 'iPad 2'
        app.devices[5].name.should == 'iPad 3 Gen'
      end
      
    end
    
  end
  
  describe "search" do
  
    describe "fresh request" do
  
      it "should make http request to itunes" do
        App.search_api(@app_query)
        WebMock.should have_requested(:get,@search_url)
      end
  
      it "should report the correct app name and version" do
        result = App.search_api(@app_query)
        result.count.should == 1
        result[0].name.should == @app_correct_name
        result[0].version.should == @app_correct_version
      end
      
    end
    
    describe "cached request" do
      
      before(:each) do
        App.search_api(@app_query) # to cache it
        App.first.update_attribute(:name,@app_incorrect_name);
      end
      
      describe "current date and version" do
        
        it "should have bad data cached" do
          result = App.first
          result.name.should == @app_incorrect_name
        end

        it "should make http request to itunes" do
          App.search_api(@app_query)
          a_request(:get, @search_url).should have_been_made.times(2)
        end

        it "should not update the app name" do
          result = App.search_api(@app_query)
          result.count.should == 1
          result[0].name.should == @app_incorrect_name
        end

      end
      
      describe "old version" do
        
        before(:each) do
          App.first.update_attribute(:version,@app_incorrect_version);
        end
        
        it "should have the old version" do
          result = App.first
          result.version.should == @app_incorrect_version
        end

        it "should make http request to itunes" do
          App.search_api(@app_query)
          a_request(:get, @search_url).should have_been_made.times(2)
        end

        it "should report the correct app name and version" do
          result = App.search_api(@app_query)
          result.count.should == 1
          result[0].name.should == @app_correct_name
          result[0].version.should == @app_correct_version
        end

      end
      
      describe "old date" do
        
        before(:each) do
          App.first.update_attribute(:updated_at,1.day.ago);
        end
        
        it "should have an old update date" do
          result = App.first
          result.updated_at.should < 1.hour.ago
        end

        it "should make http request to itunes" do
          App.search_api(@app_query)
          a_request(:get, @search_url).should have_been_made.times(2)
        end

        it "should report the correct app name and a new update date" do
          result = App.search_api(@app_query)
          result.count.should == 1
          result[0].name.should == @app_correct_name
          result[0].updated_at.should > 5.minutes.ago
        end

      end
      
    end
    
  end

  describe "lookup" do
  
    describe "fresh request" do
  
      it "should make http request to itunes" do
        App.find_api(@app_id)
        WebMock.should have_requested(:get,@find_url)
      end
  
      it "should report the correct app name and version" do
        result = App.find_api(@app_id)
        result.name.should == @app_correct_name
        result.version.should == @app_correct_version
      end
      
    end
    
    describe "cached request" do
      
      before(:each) do
        App.find_api(@app_id) # to cache it
        App.first.update_attribute(:name,@app_incorrect_name);
      end
      
      describe "current date and version" do
        
        it "should have bad data cached" do
          result = App.first
          result.name.should == @app_incorrect_name
        end
    
        it "should not make http request to itunes" do
          App.find_api(@app_id)
          a_request(:get, @find_url).should have_been_made.times(1) # initial caching
        end
    
        it "should not update the app name" do
          result = App.find_api(@app_id)
          result.name.should == @app_incorrect_name
        end
    
      end
      
      describe "old version" do
        
        before(:each) do
          App.first.update_attribute(:version,@app_incorrect_version);
        end
        
        it "should have the old version" do
          result = App.first
          result.version.should == @app_incorrect_version
        end
          
        it "should not make http request to itunes" do
          App.find_api(@app_id)
          a_request(:get, @find_url).should have_been_made.times(1)
        end
          
        it "should not update the app name or version" do
          result = App.find_api(@app_id)
          result.name.should == @app_incorrect_name
          result.version.should == @app_incorrect_version
        end
          
      end
      
      describe "old date" do
        
        before(:each) do
          App.first.update_attribute(:updated_at,1.day.ago);
        end
        
        it "should have an old update date" do
          result = App.first
          result.updated_at.should < 1.hour.ago
        end
          
        it "should make http request to itunes" do
          App.find_api(@app_id)
          a_request(:get,@find_url).should have_been_made.times(2)
        end
          
        it "should report the correct app name and a new update date" do
          result = App.find_api(@app_id)
          result.name.should == @app_correct_name
          result.updated_at.should > 5.minutes.ago
        end
          
      end
            
    end
    
  end
  
end
