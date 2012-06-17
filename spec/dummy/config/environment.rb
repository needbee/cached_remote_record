# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dummy::Application.initialize!

# Set config
App.itunes_api_server      = 'http://itunes.apple.com'
App.itunes_api_search_path = '/search?entity=software&term='
App.itunes_api_lookup_path = '/lookup?id='
