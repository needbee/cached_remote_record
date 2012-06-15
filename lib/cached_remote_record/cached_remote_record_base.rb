# A base model class for accessing records on a remote system, mapping
# them to Rails models, and caching them locally. How the remote record
# is accessed is up to the implementing class.
#
# Usage is as follows:
# * Whenever searching for records, call the search_api() method. The
#   remote repository will always be accessed. For the records that are
#   returned, they will be updated if their version has changed or if
#   the specified amount of time has passed since they were last
#   updated. This prevents having to perform potentially expensive
#   database update operations on every search.
# * Whenever pulling up an individual record, call the find_api()
#   method. The record will be loaded, then checked to see if it has
#   expired from the cache. If so, the remote repository will be
#   accessed, and the latest data will be saved. This means that a
#   record accessed in this way might not have the latest value at all
#   times.
# * When retrieving records for other purposes, such as joined in
#   relationship to other records, call the normal model methods to load
#   the record from the database. The remote reposistory will never be
#   called
#
# When implementing a model based on this class, the following
# properties and methods should be defined:
#
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
# search_remote() - Query the remote repository, and return any results
#   as a list.
# lookup_remote() - Retrieve a record from the remote repository by
#   unique ID.
#
# Author::    Josh Justice (mailto:josh@need-bee.com)
# Copyright:: Copyright (c) 2012 NeedBee, LLC
class CachedRemoteRecordBase < ActiveRecord::Base
  self.abstract_class = true

  attr_accessible :api_key 
  validates :api_key, :presence => true,
                      :uniqueness => true
  validates :version,       :presence => true

  def self.search_api(query)
    result_list = search_remote(query)
    result_list.collect do |remote_obj|
      api_key = api_key(remote_obj)
      # if does not exist in db, create it
      if 0 == count(:conditions => "api_key = #{api_key}")
        create_from_api(remote_obj)
      else
        obj = load_cached(api_key)
        if version_mismatch(obj,remote_obj) or cache_expired(obj)
          obj.update_from_api(remote_obj)
        end
        obj
      end
    end
  end
  
  def self.find_api(api_key)
    obj = load_cached(api_key)
    if obj.nil? or cache_expired(obj)
      remote_obj = lookup_remote(api_key)
      if obj.nil?
        obj = create_from_api(remote_obj)
      else
        obj.update_from_api(remote_obj)
      end
    end
    obj
  end
  
  private
  
  def self.cache_expiration
    raise NotImplementedError
  end

  def self.api_key(remote_obj)
    raise NotImplementedError
  end

  def self.extract_version(remote_obj)
    raise NotImplementedError
  end

  def self.search_remote(query)
    raise NotImplementedError
  end

  def self.lookup_remote(api_key)
    raise NotImplementedError
  end

  # Note: this is defined in the implementing class and not here because
  # it may not just be one table that is being saved; related tables may
  # also need to be saved.
  def self.create_from_api(remote_obj)
    raise NotImplementedError
  end
  
  # Note: this is defined in the implementing class and not here because
  # it may not just be one table that is being saved; related tables may
  # also need to be saved.
  def update_from_api(remote_obj)
    raise NotImplementedError
  end

  def self.load_cached(api_key)
    where(:api_key => api_key)[0]
  end
  
  def self.version_mismatch(obj,remote_obj)
    obj.version != extract_version(remote_obj)
  end
  
  def self.cache_expired(obj)
    obj.updated_at < self.cache_expiration
  end
  
end
