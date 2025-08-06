class User < ApplicationRecord
  has_secure_password
  
  has_many :orders, dependent: :destroy
  has_many :restaurants, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true
  
  enum role: { customer: 0, restaurant_owner: 1, admin: 2 }
  
  def full_address
    "#{address}, #{city}, #{state} - #{zip_code}"
  end
end
