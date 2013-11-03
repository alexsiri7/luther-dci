class Bid < ActiveRecord::Base
  belongs_to :auction

  validates :amount, presence: true
  validates :amount, numericality: true
end
