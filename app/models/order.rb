class Order < ApplicationRecord
  belongs_to :user
  belongs_to :order_status
  has_many :order_details
  has_many :products, through: :order_details
  has_one :province, through: :user
  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }

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
