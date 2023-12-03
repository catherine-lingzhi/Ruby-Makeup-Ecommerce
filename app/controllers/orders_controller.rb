# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.new(subtotal: calculate_subtotal_price)

    if @order.save
      transfer_cart_details_to_order(@order)
      clear_cart
      redirect_to root_path, notice: "Order was successfully created."
    else
      # Handle errors
      redirect_to root_path, alert: "Failed to create order."
    end
  end

  private

  def calculate_subtotal_price
    # Implement the logic to calculate the total price
    # You may have a method in your CartController to do this
    # or you can iterate through the session[:shopping_cart] directly.
  end

  def transfer_cart_details_to_order(order)
    session[:shopping_cart].each do |item|
      product = Product.find_by(id: item["id"])

      if product
        order.order_details.create(
          product_id: product.id,
          quantity:   item["quantity"],
          tax:        0.12
        )
      else
        # Handle the case where the product is not found
        # You might want to log an error or take appropriate action
        Rails.logger.error("Product with ID #{item['id']} not found.")
      end
    end
  end

  def clear_cart
    session[:shopping_cart] = []
  end
end
