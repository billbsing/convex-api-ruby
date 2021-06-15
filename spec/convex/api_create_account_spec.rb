require 'spec_helper'

describe Convex::API do
  describe '#create_account' do
    let(:url) { 'https://convex.world' }
    subject { described_class.new(url) }
    describe 'create a new account address' do
      let(:new_account) { Convex::Account.new }
      it 'is a valid address' do
        result = subject.create_account(new_account)
        expect(result).to be > 12
      end
    end
  end
end
