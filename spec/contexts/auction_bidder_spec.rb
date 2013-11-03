require 'spec_helper.rb'
require 'shared/context_test.rb'

shared_examples 'success' do
  it 'creates the bid' do
    bid.should_receive(:save).once
    call_method
  end

  include_examples 'does not call callback', :failure
  include_examples 'calls callback', :success
end

shared_examples 'failure' do
  it 'does not create the bid' do
    bid.should_not_receive(:save)
    call_method
  end

  include_examples 'does not call callback', :success
  include_examples 'calls callback', :failure
end

describe AuctionBidder do
  include_context 'context test'

  let(:amount) {10}
  let(:params) do
    { biddable_id: 1,
      bidding_params: { amount: amount } }
  end
  let(:bid) { double() }
  let(:auction) { double() }
  let(:errors) { double() }
  before do
    Bid.stub(:new) { bid }
    bid.stub(:amount) { amount }
    bid.stub(:save) { true }
    bid.stub(:errors) { errors }
    errors.stub(:add)
    Auction.stub(:find).with(1) { auction }
    auction.stub(:bids) { previous_bids }
  end
  context 'when the bidding data is invalid' do
    let(:previous_bids) { [] }
    before do
      bid.stub(:save) {false}
    end

    include_examples 'does not call callback', :success
    include_examples 'calls callback', :failure
  end
  context 'when the bidding is the first' do
    let(:previous_bids) { [] }

    include_examples 'success'
  end

  context 'when the bidding is a new high' do
    let(:previous_bids) {[double(amount: 5)]}

    include_examples 'success'
  end

  context 'when the bidding is too low' do
    let(:previous_bids) {[double(amount: 20)]}

    include_examples 'failure'
  end
end
