class AuctionCreator < Luther::DCI::Context

  def call
    self.params.auction = Auction.new auction_params
    if auction.save
      success.call self
    else
      failure.call self
    end
  end

end
