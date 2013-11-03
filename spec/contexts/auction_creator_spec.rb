require 'spec_helper.rb'
require 'shared/context_test.rb'

describe AuctionCreator do
  include_context 'context test'

  let(:params) do
    {
      auction_params: Hash.new
    }
  end

  let(:auction) { double('Auction') }

  before do
    Auction.stub(:new) { auction }
  end

  context 'when the auction can be created' do
    before do
      auction.stub(:save) { true }
    end
    include_examples 'does not call callback', :failure
    include_examples 'calls callback', :success
  end

  context 'when the auction cannot be created' do
    before do
      auction.stub(:save) { false }
    end
    include_examples 'does not call callback', :success
    include_examples 'calls callback', :failure
  end
end
