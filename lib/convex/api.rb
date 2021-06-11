
require 'http'
require 'uri'
require 'json'

class Convex::API
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def query(transaction, address=9)
    query_uri = URI(File.join(url, '/api/v1/query'))
    data = {
      'source' => transaction,
      'address' => "##{address}",
      'lang' => "convex-lisp"
    }
    response = HTTP.post(query_uri, {'json'=>data})
    if response.code == 200 then
      return JSON.parse response.body
    end
    raise Convex::RequestError(response)
  end
end
