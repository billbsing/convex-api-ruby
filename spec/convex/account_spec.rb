require "spec_helper"


private_key_text = "-----BEGIN ENCRYPTED PRIVATE KEY-----\n\
MIGbMFcGCSqGSIb3DQEFDTBKMCkGCSqGSIb3DQEFDDAcBAi3qm1zgjCO5gICCAAw\n\
DAYIKoZIhvcNAgkFADAdBglghkgBZQMEASoEENjvj1nzc0Qy22L+Zi+n7yIEQMLW\n\
o++Jzwlcg3PbW1Y2PxicdFHM3dBOgTWmGsvfZiLhSxTluXTNRCZ8ZLL5pi7JWtCl\n\
JAr4iFzPLkM18YEP2ZE=\n\
-----END ENCRYPTED PRIVATE KEY-----"

public_key = "5288Fec4153b702430771DFAC8AeD0B21CAFca4344daE0d47B97F0bf532b3306"

describe Convex::Account do
  describe "version number" do
    it "should have a version number" do
      expect(Convex::Account::VERSION).not_to be nil
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
      expect(subject.public_key).not_to be nil
    end
    it "should return a PEM formated text" do
      expect(subject.export_to_text("secret")).not_to be nil
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

  describe "import a standard key text" do
    subject { described_class.new(private_key_text, "secret")}
    it "should match the standard public key" do
      expect(subject.public_key).to eq(public_key)
    end
  end
end
