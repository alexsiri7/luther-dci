class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :auction_id
      t.float :amount

      t.timestamps
    end
  end
end
