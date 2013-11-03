class Auction < ActiveRecord::Base
  has_many :bids
  validates :name, presence: true, uniqueness: true
end
