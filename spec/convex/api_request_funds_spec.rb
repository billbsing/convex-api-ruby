require 'spec_helper'

describe Convex::API do
  describe '#request_funds' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'create a new account to request funds' do
      let(:new_account) { Convex::Account.new }
      let(:address) { subject.create_account(new_account) }

      describe 'request some preset funds' do
        let(:request_amount) { 999999 }
        it 'requests the correct amount' do
          requested_amount = subject.request_funds(address, request_amount)
          expect(requested_amount).to equal(request_amount)
        end
      end

      describe 'request the default funds' do
        it 'requests the default amount' do
          requested_amount = subject.request_funds(address)
          expect(requested_amount).to equal(Convex::DEFAULT_REQUEST_FUND_AMOUNT)
        end
      end

    end
  end
end
