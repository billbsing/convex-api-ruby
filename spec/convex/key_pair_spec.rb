require "spec_helper"


PRIVATE_KEY_TEXT = "-----BEGIN ENCRYPTED PRIVATE KEY-----\n\
MIGbMFcGCSqGSIb3DQEFDTBKMCkGCSqGSIb3DQEFDDAcBAi3qm1zgjCO5gICCAAw\n\
DAYIKoZIhvcNAgkFADAdBglghkgBZQMEASoEENjvj1nzc0Qy22L+Zi+n7yIEQMLW\n\
o++Jzwlcg3PbW1Y2PxicdFHM3dBOgTWmGsvfZiLhSxTluXTNRCZ8ZLL5pi7JWtCl\n\
JAr4iFzPLkM18YEP2ZE=\n\
-----END ENCRYPTED PRIVATE KEY-----"

PUBLIC_KEY = "5288Fec4153b702430771DFAC8AeD0B21CAFca4344daE0d47B97F0bf532b3306"

SIGN_HASH_TEXT = "5bb1ce718241bfec110552b86bb7cccf0d95b8a5f462fbf6dff7c48543622ba5"
SIGNED_TEXT = "7eceffab47295be3891ea745838a99102bfaf525ec43632366c7ec3f54db4822b5d581573aecde94c420554f963baebbf412e4304ad8636886ddfa7b1049f70e"

describe Convex::KeyPair do
  describe "version number" do
    it "should have a version number" do
      expect(Convex::KeyPair::VERSION.length).to be >  2
    end
  end

  describe "new instance" do
    subject { described_class.new }
    it "should create a new instance" do
      expect(subject).not_to be nil
    end
    it "should have a valid key" do
      expect(subject.valid?)
    end
    it "should return a public key" do
      expect(subject.public_key.length).to equal(64)
    end
    it "should return a PEM formated text" do
      expect(subject.export_to_text("secret")).to include("-----BEGIN ENCRYPTED PRIVATE KEY-----")
    end
  end

  describe "import a new key from text" do
    subject { described_class.new}
    let (:export_text) {subject.export_to_text("secret")}
    let (:import_account) {described_class::new(import_text=export_text, password="secret")}
    it "should match the imported keys" do
      expect(subject.public_key).to eq(import_account.public_key)
    end
  end

  describe "import a standard key text and sign" do
    subject { described_class.new(PRIVATE_KEY_TEXT, "secret")}
    it "should match the standard public key" do
      expect(subject.public_key).to eq(PUBLIC_KEY)
    end
    it "should sign a hash string" do
      expect(subject.sign(SIGN_HASH_TEXT)).to eq(SIGNED_TEXT)
    end
  end

  describe "import a invalid key text" do
    subject { described_class.new("invalid key text", "secret")}
    it "should have no public key value" do
      expect(subject.public_key).to be nil
    end
    it "should have an empty str value" do
      expect(subject.to_s).to eq("<empty>")
    end
    it "should export nil text" do
      expect(subject.export_to_text("ignore")).to be nil
    end
  end
end
