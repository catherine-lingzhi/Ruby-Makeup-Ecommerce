class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  before_save :calculate_tax

  private

  def calculate_tax
    user_province = order.user.province
    tax_rate = user_province.GST + user_province.PST + user_province.HST + user_province.QST
  end
end
