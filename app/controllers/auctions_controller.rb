class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
  end

  def create
    AuctionCreator.call(
      auction_params: create_params,
      success: proc {|context| redirect_to context.auction},
      failure: proc {|context|
        @auction = context.auction
        render :new
      })
  end

  def show
    @auction = AuctionPresenter.new Auction.find(params[:id])
    @bid = Bid.new
  end

  def bid
    AuctionBidder.call(
        biddable_id: params[:id],
        bidding_params: bid_params,
        success: proc {|context, message|
          flash[:notice] = message
          redirect_to context.biddable},
        failure: proc {|context, message|
          flash[:error] = message
          @auction = AuctionPresenter.new context.biddable
          @bid = context.bidding
          render :show
        })
  end

  private

  def create_params
    params.require(:auction).permit(:name, :buying_price)
  end

  def bid_params
    params.require(:bid).permit(:amount)
  end
end
