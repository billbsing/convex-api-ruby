# require_relative "account_lib/account_lib.so"


class Convex::Account

    attr_reader :address, :key_pair
    def initialize(key_pair, address)
      @address = address
      @key_pair = key_pair
    end

    def sign(hash_data)
      @key_pair.sign(hash_data)
    end

    def public_key
      @key_pair.public_key
    end

end

