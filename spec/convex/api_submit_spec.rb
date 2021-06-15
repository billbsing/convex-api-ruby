require 'spec_helper'

describe Convex::API do
  describe '#submit' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'setup an account' do
      let(:transaction) { "(map inc [1 2 3 4])" }
      it 'return as a valid completed transaciton' do
        account = Convex::Account.new
        address = subject.create_account(account)
        amount = subject.request_funds(address)
        result = subject.submit(transaction, address, account)
        expect(result["value"]).to eq([2, 3, 4, 5])
      end
    end
  end
end
