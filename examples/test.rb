#!/usr/bin/ruby

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)


require 'convex'

puts 'start query'
api = Convex::API.new('https://convex.world')
puts api.url
response = api.query('*balance*')
puts response

account = Convex::Account.new
puts "my new account key is: #{account}"
