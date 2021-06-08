
module Convex

  class Convex::API
    attr_reader :url
    private :url

    def initialize(url)
      @url = url
    end
  end
end
