require 'spec_helper'

describe Convex::API do
  describe '#request_funds' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'create a new account to request funds' do
      let(:key_pair) { Convex::KeyPair.new }
      let(:account) { subject.create_account(key_pair) }

      describe 'request some preset funds' do
        let(:request_amount) { 999999 }
        it 'requests the correct amount' do
          requested_amount = subject.request_funds(account, request_amount)
          expect(requested_amount).to equal(request_amount)
        end
      end

      describe 'request the default funds' do
        it 'requests the default amount' do
          requested_amount = subject.request_funds(account)
          expect(requested_amount).to equal(Convex::DEFAULT_REQUEST_FUND_AMOUNT)
        end
      end

    end
  end
end
