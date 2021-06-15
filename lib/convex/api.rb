
require 'http'
require 'uri'
require 'json'

class Convex::API
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def create_account(account)
    account_uri = URI(File.join(url, '/api/v1/createAccount'))
    data = {
      'accountKey': account.public_key
    }
    result = transaction_post(account_uri, data)
    result['address'].to_i
  end

  def query(transaction, address=9)
    query_uri = URI(File.join(url, '/api/v1/query'))
    data = {
      'source' => transaction,
      'address' => "##{address}",
      'lang' => "convex-lisp"
    }
    transaction_post(query_uri, data)
  end

  def submit(transaction, address, account)
    prepare_data = transaction_prepare(transaction, address)
    unless prepare_data.has_key?('hash') then
      raise Convex::APIError.new(500, 'no hash value')
    end
    hash_data = prepare_data['hash']
    account.sign(hash_data)
    transaction_submit(address, account.public_key, hash_data, signed_data)
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

end
