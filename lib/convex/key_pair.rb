##
# This class creates a KeyPair to control Convex accounts.
# The private key can be exported to text using +export_to_text+ or imported using +new+
#
#

begin
  require "convex/account_key/account_key"
rescue LoadError
end

class Convex::KeyPair

  VERSION = AccountKey::VERSION

  ##
  # Create a new +Convex::KeyPair+ object
  #
  # import_text:: If set with a encrypted PEM text of the key.
  #
  # password:: If *import_text* is used, then you need to provide the password that was used when using +export_to_text+
  #
  # ==== Example
  #
  #   # Create a random key
  #   key = Convex::KeyPair.new
  #
  #   # export the key to a encrypted PEM text
  #   pem_text = key.export_to_text('secret')
  #
  #   # re-import the same key
  #   saved_key = Convex::KeyPair.new(pem_text, 'secret')
  #
  #   "keys are equal" if saved_key.eql?(key)
  #
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

  def sign(hash_data)
    @key.sign(hash_data) if @key
  end

  def valid?
    @key != false
  end

  def eql?(other)
    public_key == other.public_key
  end

  def to_s
    public_key if valid?
    "<empty>"
  end
end

