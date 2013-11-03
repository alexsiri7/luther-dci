class AuctionPresenter < SimpleDelegator
  def best_bid
    bids.order('amount DESC').first.amount
  end
end
