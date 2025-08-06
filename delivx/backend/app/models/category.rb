class Category < ApplicationRecord
  has_many :foods, dependent: :destroy
  has_many :restaurant_categories, dependent: :destroy
  has_many :restaurants, through: :restaurant_categories
  
  validates :name, presence: true, uniqueness: true
  
  scope :active, -> { where(active: true) }
end
