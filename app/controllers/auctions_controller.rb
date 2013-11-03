class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
  end

  def create
    AuctionCreator.call create_params, self
  end

  def show
    @auction = AuctionPresenter.new Auction.find(params[:id])
    @bid = Bid.new
  end

  def bid
    AuctionBidder.call bid_params, params[:id], self
  end

  def auction_success(auction)
    redirect_to auction
  end

  def auction_failure auction
    @auction = auction
    render :new
  end

  def bidder_success(bid, auction)
    redirect_to auction
  end

  def bidder_failure(bid, auction)
    @auction = auction
    @bid = bid
    render :show
  end

  private

  def create_params
    params.require(:auction).permit(:name)
  end

  def bid_params
    params.require(:bid).permit(:amount)
  end
end
