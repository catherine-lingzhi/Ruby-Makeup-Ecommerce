class Order < ApplicationRecord
  belongs_to :user
  belongs_to :order_status
  has_many :order_details, dependent: :destroy
  has_one :province, through: :user

  def gst
    province&.GST || 0
  end

  def pst
    province&.PST || 0
  end

  def hst
    province&.HST || 0
  end
end
