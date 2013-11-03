class AuctionBidder < Luther::DCI::Context

  role :bidding_params do
    def create_bid
      Bid.new self.merge(auction: context.biddable.player)
    end
  end

  role :bidding do
    def validate_and_save
      greater_than_last_bidding && save
    end

    def greater_than_last_bidding
      if amount >= context.biddable.last_bid_amount
        true
      else
        self.errors.add :amount, "You need to bid more than the previous bidder."
        false
      end
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
    if bidding.validate_and_save
      success.call(self)
    else
      failure.call(self)
    end
  end

end
