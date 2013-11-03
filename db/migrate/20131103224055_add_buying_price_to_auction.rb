class AddBuyingPriceToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :buying_price, :float
  end
end
