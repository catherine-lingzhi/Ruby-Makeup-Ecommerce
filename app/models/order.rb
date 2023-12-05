class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_one :province, through: :user
  belongs_to :order_status

  def gst
    province&.GST || 0
  end

  def pst
    province&.PST || 0
  end

  def hst
    province&.HST || 0
  end

  def line_items_for_stripe
    order_details.map do |order_detail|
      {
        price_data: {
          currency:     "cad",
          product_data: {
            name:        order_detail.product.name,
            description: order_detail.product.description
          },
          unit_amount:  (order_detail.price * 100).to_i # Convert the price to cents
        },
        quantity:   order_detail.quantity
      }
    end
  end
end
