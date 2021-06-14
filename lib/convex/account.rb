# require_relative "account_lib/account_lib.so"

begin
  require "convex/account_key/account_key"
rescue LoadError
end

class Convex::Account

    VERSION = AccountKey::VERSION

    def initialize(import_text=nil, password=nil)
      if import_text and password then
        @key = AccountKey::create_from_text(import_text, password)
      else
        @key = AccountKey::create
      end
    end

    def public_key
      @key.public_key if @key
    end

    def export_to_text(password)
      @key.export_to_text(password) if @key
    end

    def sign(hash_hex)
      @key.sign(hash_hex) if @key
    end

    def valid?
      @key != false
    end

    def to_s
      public_key if valid?
      "<empty>"
    end
end

