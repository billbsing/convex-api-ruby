require 'spec_helper'

describe Convex::API do
  describe '#submit' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'setup an account and submit a transaction' do
      let(:transaction) { "(map inc [1 2 3 4])" }
      it 'return as a valid completed transaciton' do
        key_pair = Convex::KeyPair.new
        account = subject.create_account(key_pair)
        amount = subject.request_funds(account)
        result = subject.submit(transaction, account)
        expect(result["value"]).to eq([2, 3, 4, 5])
      end
    end
  end
end
