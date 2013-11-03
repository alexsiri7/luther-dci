class AuctionBidder < DCI::Context
  def self.call *params
    auction_creator = self.new(*params).call
  end

  def initialize params, auction_id, listener
    @params, @auction_id, @listener = params, auction_id, listener
  end

  def call
    @bid = Bid.new @params.merge(auction_id: @auction_id)
    if @bid.save
      @listener.bidder_success(@bid, @bid.auction)
    else
      @listener.bidder_failure(@bid, @bid.auction)
    end
  end

end
