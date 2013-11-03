class AuctionBidder < Luther::DCI::Context

  class BiddingError < StandardError; end

  role :bidding_params do
    def create_bid
      Bid.new self.merge(auction: context.biddable.player)
    end
  end

  role :bidding do
    def validate_and_save
      greater_than_last_bidding
      does_not_exceed_buying_price
      save!
    end

    def greater_than_last_bidding
      if amount > context.biddable.last_bid_amount
        true
      else
        fail BiddingError, "You need to outbid the previous bidder."
      end
    end

    def does_not_exceed_buying_price
      fail BiddingError, "You can't exceed the buying price" unless context.biddable.buying_price >= amount
    end
  end

  role :biddable do
    def last_bid_amount
      bids.last.try(:amount).to_i
    end
  end

  def call
    self.biddable = Auction.find biddable_id
    self.bidding = bidding_params.create_bid
    begin
      bidding.validate_and_save
      success.call(self, 'Your bid has been recorded')
    rescue BiddingError, ActiveRecord::RecordInvalid => e
      failure.call(self, e.message)
    end
  end

end
