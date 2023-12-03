# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def create
    @order = Order.create(order_status: 0, subtotal: 0, user_id: current_user.id)
    total_price = 0
    if @order.save
      Rails.logger.debug("Order saved successfully: #{@order.inspect}")

      session[:shopping_cart].each do |item|
        product = Product.find_by(id: item["id"])
        quantity = item["quantity"]
        subtotal = product.price * quantity
        total_price += subtotal
        @order.order_details.create(
          quantity:,
          price:      product.price,
          product_id: product.id,
          tax:        0.13
        )
      end
      session[:shopping_cart] = nil
      # Redirect or perform other actions as needed
    else
      # Handle errors
    end
    @order.update(subtotal: total_price)
  end

  private

  def calculate_tax(price)
    # Implement your tax calculation logic here
  end
end
