require 'spec_helper'

describe Convex::API do
  describe '#get_account_info' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'request account #9 for info' do
      let(:address) { 9}
      it 'return account information' do
        result = subject.get_account_info(address)
        expect(result).to include('balance')
        expect(result).to include('account-key')
        expect(result).to include('controller')
        expect(result).to include('sequence')
      end
    end
  end
end

