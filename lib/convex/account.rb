# require_relative "account_lib/account_lib.so"

begin
  require "convex/account_key/account_key"
rescue LoadError
end

class Convex::Account
    VERSION = "0.0.1"


    def initialize(import_text=nil, password=nil)
      if import_text and password then
        @key = AccountKey::create_from_text(import_text, password)
      else
        @key = AccountKey::create
      end
    end

    def public_key
      return @key.public_key
    end

    def export_to_text(password)
      return @key.export_to_text(password)
    end

    def valid?
      return @key != false
    end

    def to_s
      if valid? then
        return public_key
      end
      return "<empty>"
    end
end

