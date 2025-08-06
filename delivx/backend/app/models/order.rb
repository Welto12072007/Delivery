class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy
  
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :delivery_address, presence: true
  validates :status, presence: true
  
  enum status: { 
    pending: 0, 
    confirmed: 1, 
    preparing: 2, 
    ready: 3, 
    delivering: 4, 
    delivered: 5, 
    cancelled: 6 
  }
  
  def total_with_delivery
    total_amount + restaurant.delivery_fee
  end
  
  def formatted_total
    "R$ #{sprintf('%.2f', total_with_delivery)}"
  end
end
