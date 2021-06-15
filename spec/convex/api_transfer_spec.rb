require 'spec_helper'

describe Convex::API do
  describe '#transfer' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'setup an account and transfer to #9' do
      let(:transfer_amount) { 1000 }
      let(:to_address) { 9 }
      it 'returns a valid transfer amount' do
        from_key_pair = Convex::KeyPair.new
        from_account = subject.create_account(from_key_pair)
        amount = subject.request_funds(from_account)
        result = subject.transfer(from_account, to_address, transfer_amount)
        expect(result).to be == transfer_amount
      end
    end
  end
end
