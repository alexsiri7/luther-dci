class Bid < ActiveRecord::Base
  belongs_to :auction

  validates :auction, presence: true
  validates :amount, presence: true
  validates :amount, numericality: true
end
