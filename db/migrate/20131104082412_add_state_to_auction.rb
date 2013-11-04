class AddStateToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :state, :string, default: 'open'
  end
end
