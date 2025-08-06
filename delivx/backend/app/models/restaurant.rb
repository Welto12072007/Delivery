class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :foods, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
  
  has_one_attached :image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :delivery_time, presence: true
  validates :delivery_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_order, presence: true, numericality: { greater_than: 0 }
  
  scope :active, -> { where(active: true) }
  scope :by_rating, -> { order(rating: :desc) }
  
  def average_rating
    orders.where.not(rating: nil).average(:rating) || 0
  end
  
  def full_address
    "#{address}, #{city}, #{state} - #{zip_code}"
  end
end
