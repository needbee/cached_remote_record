class AppDevice < ActiveRecord::Base
  attr_accessible :app_id, :device_id, :app, :device
  belongs_to :app
  belongs_to :device
  
  validates :app_id,    :presence => true
  validates :device_id, :presence => true
end
