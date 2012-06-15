# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dummy::Application.initialize!

# Set config
Dummy::Application.config.itunes_api_server      = 'http://itunes.apple.com'
Dummy::Application.config.itunes_api_search_path = '/search?entity=software&term='
Dummy::Application.config.itunes_api_lookup_path = '/lookup?id='
