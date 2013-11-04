require 'spec_helper.rb'
require 'shared/context_test.rb'

# class ActiveRecord::RecordInvalid < StandardError; end

shared_examples 'success' do
  it 'creates the bid' do
    bid.should_receive(:save!).once
    call_method
  end

  include_examples 'does not call callback', :failure
  include_examples 'calls callback', :success
end

shared_examples 'failure' do
  it 'does not create the bid' do
    bid.should_not_receive(:save!)
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
  let(:class_mock) {double('class_mock', i18n_scope: nil)}
  let(:bid) { double(amount: amount, save!: true, errors: errors, class: class_mock) }
  let(:auction) { double(buying_price: buying_price, bids: previous_bids, open?: true) }
  let(:errors) { double(add: nil, full_messages: []) }
  let(:buying_price) { 50 }
  let(:previous_bids) { [] }
  before do
    Bid.stub(:new) { bid }
    Auction.stub(:find).with(1) { auction }
    bid.stub(:transaction).and_yield
  end
  context 'when the bidding data is invalid' do
    before do
      bid.stub(:save!) { raise ActiveRecord::RecordInvalid.new(bid) }
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

  context 'when the bidding is equal to the max' do
    let(:previous_bids) {[double(amount: 10)]}

    include_examples 'failure'
  end


  context 'when the bidding is over the buying price' do
    let(:amount) { 60 }

    include_examples 'failure'
  end

  context 'when the bidding is equal to the buying price' do
    let(:amount) { 50 }
    before do
      auction.stub(:close!)
    end

    include_examples 'success'
    it 'closes the bid' do
      auction.should_receive(:close!)

      call_method
    end
  end

  context 'when the auction is not open' do
    before do
      auction.stub(:open?) {false}
    end
    include_examples 'failure'
  end

end
