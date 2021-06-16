
require "spec_helper"

describe Convex::API do

  let(:url) {['https://convex.world']}
  subject { described_class.new(url) }

  context 'after creating a new object' do
    it 'should return a new object' do
      expect(subject).to be_an_instance_of(Convex::API)
      expect(subject.url).to be == url
    end
  end
  context 'after calling a query' do
    let(:valid_balance) { 999999999 }
    it 'should return a valid query result' do
      result = subject.query('*balance*')
      expect(result["value"]).to be > valid_balance
    end
  end
  context 'after creating a new account' do
    before do
      @key_pair = Convex::KeyPair.new
      @account = subject.create_account(@key_pair)
    end
    it 'should have a valid address number' do
      expect(@account.address).to be > 12
    end

    context 'after requesting account information' do
      it 'should return a valid account record' do
        result = subject.get_account_info(@account.address)
        expect(result).to include('balance')
        expect(result).to include('account-key')
        expect(result).to include('controller')
        expect(result).to include('sequence')
      end
    end

    context 'after requesting a fixed amount funds' do
      let(:request_amount) { 10000 }
      it 'should request the correct amount' do
          amount = subject.request_funds(@account, request_amount)
          expect(amount).to equal(request_amount)
        end
    end

    context 'after requesting a default amount funds' do
      it 'should have requested the default amount' do
        amount = subject.request_funds(@account)
        expect(amount).to equal(Convex::DEFAULT_REQUEST_FUND_AMOUNT)
      end
    end
    context 'after submiting a transaction' do
      let(:transaction) { "(map inc [1 2 3 4])" }
      it 'should return a valid transaction result' do
        amount = subject.request_funds(@account)
        result = subject.submit(transaction, @account)
        expect(result["value"]).to eq([2, 3, 4, 5])
      end
    end
    context 'after transfer an amount' do
    let(:transfer_to_address) { 9 }
    let(:transfer_amount) { 10000 }
      it 'should return the amount transfered' do
        amount = subject.request_funds(@account)
        result = subject.transfer(@account, transfer_to_address, transfer_amount)
        expect(result).to be == transfer_amount
      end
    end
  end
end
