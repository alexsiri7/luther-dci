class AuctionPresenter < SimpleDelegator
  def best_bid
    bids.order('amount DESC').first.try :amount
  end
  def new_bid_form
    if open?
      yield
    end
  end
end
