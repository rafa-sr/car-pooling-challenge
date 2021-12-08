# frozen_string_literal: true

require 'bundler'
Bundler.require :default
MultiJson.use :oj

require_all 'config/**.rb'
require_all 'services/**/*.rb'
require_all 'models/**.rb'

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/cross_origin'

use Rack::JSON

require_relative 'config/rack_json'

# require_all 'serializers/**.rb'
require_all 'controllers/**.rb'
