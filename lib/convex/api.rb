##
# This class provides API connection to the Convex network
#

require 'http'
require 'uri'
require 'json'


class Convex::API
  attr_reader :url

  ##
  # Creates a new API object. You need to pass the network URL of the Convex network
  #
  # At the moment this is {\https://convex.world}[https://convex.world]
  #
  # ==== Example
  #
  #   convex = Convex::API.new('https://convex.world')
  #
  def initialize(url)
    @url = url
  end

  ##
  # Creates a new account, using the provided +KeyPair+.
  #
  # key_pair:: A valid +Convex::KeyPair+ object that contains a private and public key.
  #
  # returns:: A +Convex::Account+ object.
  #
  # ==== Example
  #
  #   # create a random key pair value
  #   key_pair = Convex::KeyPair.new
  #
  #   account = convex.create_account(key_pair)
  #   puts "my new address is #{account.address}"
  #
  def create_account(key_pair)
    account_uri = URI(File.join(url, '/api/v1/createAccount'))
    data = {
      'accountKey': key_pair.public_key
    }
    result = transaction_post(account_uri, data)
    address = result['address'].to_i
    return Convex::Account.new(key_pair, address)
  end

  ##
  # Request funds from the test network. At the moment this will work since we are
  # using a test network.
  #
  # The amount of funds requested is returned.
  #
  # account:: The account to request funds for.
  #
  # amount:: Optional amount to request. If none provided then request the default amount.
  #
  # returns:: The amount of funds requested.
  #
  # ==== Example
  #
  #   account = convex.create_account(key_pair)
  #   amount = convex.request_funds(account)
  #   puts "I have requested #{amount} coins for my new account at #{account.address}"
  #
  def request_funds(account, amount=0)
    amount = Convex::DEFAULT_REQUEST_FUND_AMOUNT if amount == 0
    faucet_uri = URI(File.join(url, '/api/v1/faucet'))
    data = {
      'address': "##{account.address}",
      'amount': amount
    }
    result = transaction_post(faucet_uri, data)
    result['amount'].to_i
  end

  ##
  # Query the Convex network with a *convex-lisp* statement.
  #
  # All queries to the network are free, and you do not need an account to sign the
  # transaction.
  #
  # transaction:: transaction to execute as a query
  #
  # address:: Optional account address to run the query from.
  #
  # returns:: The query result
  #
  # ==== Example
  #
  #   account = convex.create_account(key_pair)
  #   amount = convex.query('*balance*', account.address)
  #   puts "My account has #{amount} coins"
  #
  def query(transaction, address=11)
    query_uri = URI(File.join(url, '/api/v1/query'))
    data = {
      'source' => transaction,
      'address' => "##{address}",
      'lang' => "convex-lisp"
    }
    transaction_post(query_uri, data)
  end

  ##
  # Get account infomation.
  #
  # address:: Address of the account to get the information for.
  #
  # returns:: The result from calling the account information API on the Convex network.
  #
  # ==== Example
  #
  #   info = convex.get_account_info(account.address)
  #   puts "account info #{info}"
  #
  def get_account_info(address)
    info_uri =  URI(File.join(url, "/api/v1/accounts/#{address}"))
    transaction_get(info_uri)
  end

  ##
  # Submit a transaction to the network. As this transcation will change the network state
  # you will need to have an account that can sign the transaction and also have sufficient
  # funds in the account.
  #
  # transaction:: Transaction to execute on the network.
  #
  # account:: A valid +Convex::Account+ object.
  #
  # returns:: The result from the transaction.
  #
  # ==== Example
  #
  #   result = convex.submit("map inc [1 2 3 4]"), account)
  #   puts "my result is #{result}"
  #
  def submit(transaction, account)
    prepare_data = transaction_prepare(transaction, account.address)
    unless prepare_data.has_key?('hash') then
      raise Convex::APIError.new(500, 'no hash value')
    end
    hash_data = prepare_data['hash']
    signed_data = account.sign(hash_data)
    transaction_submit(account.address, account.public_key, hash_data, signed_data)
  end

  ##
  # Transfer funds from an account to a given address.
  #
  # from_account:: The valid +Convex::Account+ object that has sufficient funds to transfer from.
  #
  # to_address:: The address to send the funds to.
  #
  # amount:: The amount to send to the *to_address*
  #
  # ==== Example
  #
  #   to_address = 9
  #   amount = convex.transfer(account, to_address, 10000)
  #   puts "I have sent #{amount} to address #{to_address}"
  #
  def transfer(from_account, to_address, amount)
    transaction = "(transfer ##{to_address} #{amount})"
    result = submit(transaction, from_account)
    result['value'] if result.has_key?('value')
  end

  protected def transaction_prepare(transaction, address, sequence_number=nil)
    prepare_uri = URI(File.join(url, '/api/v1/transaction/prepare'))
    data = {
      'address' => "##{address}",
      'source' => transaction,
      'lang' => "convex-lisp"
    }
    if sequence_number then
      data['sequence'] = sequence_number
    end
    transaction_post(prepare_uri, data)
  end

  protected def transaction_submit(address, public_key, hash_data, signed_data)
    submit_uri = URI(File.join(url, '/api/v1/transaction/submit'))
    data = {
      'address' => "##{address}",
      'accountKey' => public_key,
      'hash': hash_data,
      'sig': signed_data
    }
    transaction_post(submit_uri, data)
  end

  protected def transaction_post(uri, data)
    response = HTTP.post(uri, {'json'=>data})
    if response.code != 200 then
      raise Convex::APIError.new(response.code, response.body)
    end
    result = JSON.parse response.body
    if result.has_key?('errorCode') then
      raise Convex::APIError.new(result['errorCode'], result['value'])
    end
    result
  end

  protected def transaction_get(uri)
    response = HTTP.get(uri)
    if response.code != 200 then
      raise Convex::APIError.new(response.code, response.body)
    end
    result = JSON.parse response.body
    if result.has_key?('errorCode') then
      raise Convex::APIError.new(result['errorCode'], result['value'])
    end
    result
  end

end
