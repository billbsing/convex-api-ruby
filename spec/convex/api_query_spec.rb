require 'spec_helper'

describe Convex::API do
  describe '#query' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }

    describe 'get balance from account #9' do
      let(:valid_balance) { 999999999 }
      it 'is expected query a valid balance' do
        response = subject.query('*balance*')
        expect(response["value"]).to be > valid_balance 
      end
    end
  end
end
