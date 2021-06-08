require 'spec_helper'

describe 'Query' do
  describe 'basic' do
    before do
      @api = Convex::API.new('https://convex.world') 
    end

    describe 'get balance from account #9' do
      let(:valid_balance) { 999999999 }
      before do
        @response = @api.query('*balance*')
      end
      it 'is expected a valid balance' do
        expect(@response["value"]).to be > valid_balance 
      end
    end
  end
end
