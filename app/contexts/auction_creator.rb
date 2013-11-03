class AuctionCreator < DCI::Context
  def self.call *params
    auction_creator = self.new(*params).call
  end

  def initialize params, listener
    @params, @listener = params, listener
  end

  def call
    @auction = Auction.new @params
    if @auction.save
      @listener.creator_success
    else
      @listener.creator_failure
    end
  end

end
