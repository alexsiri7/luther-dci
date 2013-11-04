class Auction < ActiveRecord::Base
  has_many :bids
  validates :name, presence: true, uniqueness: true
  validates :buying_price, presence: true, numericality: {greater_than: 0}

  def open?
    state=='open'
  end

  def close!
    self.state='closed'
    save!
  end
end
