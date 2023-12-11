class Province < ApplicationRecord
  has_many :users
  validates :name, presence: true, length: { maximum: 255 }
end
