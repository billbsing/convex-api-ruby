#!/usr/bin/ruby 

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)


require 'convex'

Convex::API.new('https://convex.world') do |api| 
  puts api.url
end
