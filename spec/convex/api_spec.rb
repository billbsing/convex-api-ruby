
require "spec_helper"

describe Convex::API do
  let(:url) {['https://convex.world']}
  subject { described_class.new(*url) }

  it 'creates a new api class instance' do
    expect(subject) == url
  end

end
