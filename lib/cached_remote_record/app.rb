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

# Model class representing an App in the iTunes App store. Based on
# CachedWebServiceRecord class, which provides web service connectivity
# and caching.
#
# Author::    Josh Justice (mailto:josh@need-bee.com)
# Copyright:: Copyright (c) 2012 NeedBee, LLC
class App < CachedWebServiceRecord
  attr_accessible :icon_url, :company_name, :company_url, :description, :file_size_bytes, :category, :itunes_rating, :itunes_link, :name, :price, :release_date, :release_notes, :version, :devices
  has_many :app_devices
  has_many :devices, :through => :app_devices
  
  validates :name,          :presence => true
  validates :price,         :presence => true
  validates :category,      :presence => true
  validates :icon_url,      :presence => true
  validates :itunes_link,   :presence => true
  validates :itunes_rating, :presence => true
                    
  @@data_type = 'json'

  def update_from_api(json_obj)
    if !json_obj.nil?
      update_attributes!( App.get_field_hash(json_obj) )
    end
  end
  
  private

  def self.get_field_hash(json_obj)
    {
      :version          => json_obj['version'],
      :name             => json_obj['trackName'],
      :price            => json_obj['price'],
      :file_size_bytes  => json_obj['fileSizeBytes'],
      :release_date     => json_obj['releaseDate'],
      :category         => json_obj['primaryGenreName'],
      :itunes_rating    => json_obj['averageUserRating'],
      :company_name     => json_obj['sellerName'],
      :description      => json_obj['description'],
      :release_notes    => json_obj['releaseNotes'],
      :company_url      => json_obj['sellerUrl'],
      :icon_url         => json_obj['artworkUrl60'],
      :itunes_link      => json_obj['trackViewUrl'],
      :devices          => get_devices_from_api(json_obj)
    }
  end
  
  def self.create_from_api(json_obj)
    if !json_obj.nil?
      devices = get_devices_from_api(json_obj)
      App.create( get_field_hash(json_obj).merge(
          :api_key => json_obj['trackId']
      ))
    end
  end
  
  def self.get_devices_from_api(json_obj)
    codes = json_obj['supportedDevices']
    if codes.length == 1 and codes[0] == 'all' then
      Device.all
    else
      devices = []
      json_obj['supportedDevices'].each do |code|
        SupportedDeviceCode.find_all_by_code(code).each do |code_record|
          devices = devices | [code_record.device]
        end
      end
      devices
    end
  end
  
  def self.api_server
    Dummy::Application.config.itunes_api_server
  end
  
  def self.api_search_path(escaped_query)
    "#{Dummy::Application.config.itunes_api_search_path}#{escaped_query}"
  end

  def self.api_lookup_path(escaped_api_key)
    "#{Dummy::Application.config.itunes_api_lookup_path}#{escaped_api_key}"
  end

  def self.extract_search_results(json_results_obj)
    json_results_obj['results']
  end
  
  def self.extract_lookup_results(json_results_obj)
    extract_search_results(json_results_obj)[0]
  end
  
  def self.api_key(json_obj)
    json_obj['trackId']
  end

  def self.extract_version(json_obj)
    json_obj['version']
  end

  def self.cache_expiration
    1.hour.ago
  end

end
