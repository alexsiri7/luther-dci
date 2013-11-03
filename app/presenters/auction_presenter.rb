class AuctionPresenter < SimpleDelegator
  def best_bid
    bids.order('amount DESC').first.try :amount
  end
end
