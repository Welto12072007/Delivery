class Food < ApplicationRecord
  belongs_to :restaurant
  belongs_to :category
  has_many :order_items, dependent: :destroy
  
  has_one_attached :image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  scope :available, -> { where(available: true) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_price_range, ->(min, max) { where(price: min..max) }
  
  def formatted_price
    "R$ #{sprintf('%.2f', price)}"
  end
end
