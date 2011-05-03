require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra/base'
require 'json'

require File.join(File.dirname(__FILE__), 'lib', 'task_request')
require File.join(File.dirname(__FILE__), 'lib', 'task')
require File.join(File.dirname(__FILE__), 'lib', 'data_store')

# URI Regex /<TIME IDENTIFIER>/(<TAG>|<FILTER>|<IMPORTANCE>)*
UriRe = %r{^/(\d\d-\d\d-\d\d\d\d|[0-9a-zA-Z\-]+)((/[a-zA-Z0-9\-!]+)*)?$}

class Rote < Sinatra::Application

  before do
    content_type 'text/plain' # 'text/yaml'
  end

  get UriRe do
    Task.find(TaskRequest.new(params[:captures][0])).map { |task| task.to_yaml }
  end

  post UriRe do
    Task.create(TaskRequest.new(params[:captures][0]), request).to_yaml
  end

  delete UriRe do
    Task.delete(TaskRequest.new(params[:captures][0]))
  end
  # TODO
  # put task_uri do
  #   
  # end
end