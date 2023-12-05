class Product < ApplicationRecord
  belongs_to :category
  validates :name, :price, presence: true
  has_many :order_details
  has_one_attached :image
end
