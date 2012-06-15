require 'rest_client'
require 'json'

# A base model class for accessing records via a web service, mapping
# them to Rails models, and caching them locally. This class provides
# web service access functionality; the parent class CachedRemoteRecord
# provides caching functionality. Implementing classes describe at what
# address to access the web service, what data type to expect, and how
# the returned data maps into one or more model records.
#
# When implementing a model based on this class, the following
# properties and methods should be defined:
#
# @@data_type - The type of data expected back from the web service--
#   either 'text' or 'json'. If 'json', the data returned will be parsed
#   before it is passed to the appropriate extract...() method.
# api_server() - Should return the server name
# api_search_path() - Should return the path on the server to search for
#   records by a query. This is the path used when search_api() is
#   called. The query is passed in already URL-escaped.
# api_lookup_path() - Should return the path on the server to retrieve a
#   record by primary key. This is the path used when find_api() is
#   called. The primary key is passed in already URL-escaped.
# extract_search_results() - This method is passed the entire web
#   service result, and it should return an array of the data for each
#   record.
# extract_lookup_results() - This method is passed the entire web
#   service result, and it should return the data for the record.
# cache_expiration() - Return the time that, as of right now, records
#   should expire (i.e. 1.hour.ago, etc.)
# api_key() - For the passed-in remote object data, return its unique ID
#   from the remote repository.
# extract_version() - For the passed-in remote object data, return a
#   value indicating its version. This value should change if and only
#   if the object has been updated.
# create_from_api() - Take the passed in remote object data (as returned)
#   from search_remote() or lookup_remote()) and create a new record
#   based on it.
# update_from_api() - Take the passed in remote object data (as returned)
#   and update "this" record with its data.
#
# Author::    Josh Justice (mailto:josh@need-bee.com)
# Copyright:: Copyright (c) 2012 NeedBee, LLC
class CachedWebServiceRecord < CachedRemoteRecordBase
  self.abstract_class = true
  @@data_type = 'text'

  private
  
  def self.api_server
    raise NotImplementedError
  end
  
  def self.api_search_path(escaped_query)
    raise NotImplementedError
  end

  def self.api_lookup_path(escaped_api_key)
    raise NotImplementedError
  end

  def self.extract_search_results(json_results_obj)
    raise NotImplementedError
  end
  
  def self.extract_lookup_results(json_results_obj)
    raise NotImplementedError
  end
  
  def self.search_remote(query)
    result = RestClient.get(api_server+api_search_path(URI.escape(query)))
    extract_search_results(parse_results(result))
  end

  def self.lookup_remote(api_key)
    result = RestClient.get(api_server+api_lookup_path(URI.escape(api_key)))
    extract_lookup_results(parse_results(result))
  end

  def self.parse_results(text)
    case @@data_type
    when 'json'
      return JSON.parse(text)
    else
      return text
    end
  end
  
end
