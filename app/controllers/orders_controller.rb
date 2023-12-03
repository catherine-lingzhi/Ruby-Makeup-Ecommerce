# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @orders = Order.create(order_status: 0, subtotal: 0, user_id: current_user.id)
    total_price = 0
    if @orders.save
      Rails.logger.debug("Order saved successfully: #{@order.inspect}")

      gst = current_user.province&.GST || 0
      pst = current_user.province&.PST || 0
      hst = current_user.province&.HST || 0
      qst = current_user.province&.QST || 0
      tax = gst + pst + hst + qst

      session[:shopping_cart].each do |item|
        product = Product.find_by(id: item["id"])
        quantity = item["quantity"]
        subtotal = product.price * quantity
        total_price += subtotal
        @orders.order_details.create(
          quantity:,
          price:      product.price,
          product_id: product.id,
          tax:        product.price * (gst + pst + hst)
        )
      end
      @orders.update(subtotal: total_price)
      session[:shopping_cart] = nil

      redirect_to orders_path(@orders.id), notice: "Order was successfully created."
    else
      # Handle errors
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    redirect_to orders_path, notice: "Order was successfully destroyed."
  end
end
