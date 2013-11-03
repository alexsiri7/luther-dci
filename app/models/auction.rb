class Auction < ActiveRecord::Base
  has_many :bids
  validates :name, presence: true, uniqueness: true
  validates :buying_price, presence: true, numericality: {greater_than: 0}
end
