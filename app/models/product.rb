class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details
  has_many :orders, through: :order_details
  has_one_attached :image

  validates :name, :price, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
