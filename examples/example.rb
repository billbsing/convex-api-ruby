#!/usr/bin/ruby

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)


require 'convex'

api = Convex::API.new('https://convex.world')
puts api.url

# this is free, to do a query
puts 'start query'
response = api.query('*balance*')
puts response

# create a new random key pair
key_pair = Convex::KeyPair.new
puts "my new account key is: #{key_pair}"

# create a new account address on Convex
account = api.create_account(key_pair)
puts "my new address is: #{account.address}"

# request some funds for this new account
api.request_funds(account)

# submit a transaction, it will cost you some funds to do this
transaction = "(map inc [1 2 3 4 5])"
result = api.submit(transaction, account)
puts "my result from a submit is: #{result}"
