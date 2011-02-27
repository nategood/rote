require 'mongo'
require 'singleton'

class DataStore
  include Singleton
  CONF = {:host => 'localhost', :port => 27017, :db => 'rote', :collection => 'tasks'}
  def initialize
    @@collection = Mongo::Connection.new(DataStore::CONF[:host], DataStore::CONF[:port]).db(DataStore::CONF[:db]).collection(DataStore::CONF[:collection])
  end
  def collection
    @@collection
  end
end 