class Order < ApplicationRecord
  belongs_to :user
  belongs_to :order_status
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

  def save_payment_id(payment_id)
    update(payment_id:)
  end

  def mark_as_paid
    update(order_status: OrderStatus.find_by(name: "Paid"))
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
