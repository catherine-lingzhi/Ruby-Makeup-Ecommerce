class OrdersController < ApplicationController
  include SendGrid

  def index
    @orders = current_user.orders.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    newstatus = OrderStatus.find_by_name("new")

    @order = Order.create(subtotal: 0, user_id: current_user.id, order_status: newstatus)
    total_price = 0
    return unless @order.save!

    Rails.logger.debug("Order saved successfully: #{@order.inspect}")

    gst = current_user.province&.GST || 0
    pst = current_user.province&.PST || 0
    hst = current_user.province&.HST || 0

    session[:shopping_cart].each do |item|
      product = Product.find_by(id: item["id"])
      quantity = item["quantity"]
      subtotal = product.price * quantity
      total_price += subtotal
      @order.order_details.create(
        quantity:,
        price:      product.price,
        product_id: product.id,
        tax:        product.price * (gst + pst + hst)
      )
    end
    @order.update(subtotal: total_price)

    to_email = current_user.email
    subject = "Order Confirmation"
    content = "Thanks for your order!Please pay the order in three days.Thanks!"
    email_response = send_email(to_email, subject, content)

    session[:shopping_cart] = nil
    Rails.logger.debug("Validation Errors: #{@order.errors.full_messages}")
    Rails.logger.debug("Redirecting to order show page with ID: #{@order.id}")
    redirect_to order_path(@order.id)
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    redirect_to orders_path, notice: "Order was successfully destroyed."
  end

  private

  def send_email(to, subject, content)
    from_email = Email.new(email: "lingzhiluo8@outlook.com")
    to_email = Email.new(email: to)
    mail = Mail.new(from_email, subject, to_email, Content.new(type: "text/plain", value: content))

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    response = sg.client.mail._("send").post(request_body: mail.to_json)

    { status_code: response.status_code, body: response.body, headers: response.headers }
  end
end
