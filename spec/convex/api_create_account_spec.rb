require 'spec_helper'

describe Convex::API do
  describe '#create_account' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'create a new account address' do
      let(:key_pair) { Convex::KeyPair.new }
      it 'is a valid address' do
        account = subject.create_account(key_pair)
        expect(account.address).to be > 12
      end
    end
  end
end
