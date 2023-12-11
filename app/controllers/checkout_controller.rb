class CheckoutController < ApplicationController
  include SendGrid
  # POST /checkout/create
  # a product id will be in the params hash params[:product_id]
  def create
    # Load up the existing order and its order details:
    @order = Order.find(params[:order_id])
    session[:order_id] = @order.id

    # Establish a connection with Stripe and then redirect the user to the payment screen.
    @session = Stripe::Checkout::Session.create({
                                                  payment_method_types: ["card"],
                                                  mode:                 "payment",
                                                  success_url:          checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
                                                  cancel_url:           checkout_cancel_url,

                                                  line_items:           @order.line_items_for_stripe
                                                })

    redirect_to @session.url, allow_other_host: true
  end

  def success
    # We took the customer's money!
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    @order = Order.find(session[:order_id])

    if @order
      to_email = current_user.email
      subject = "Payment Confirmation"
      content = "We got you payment! We will delivery to you as soon as possioble!"
      email_response = send_email(to_email, subject, content)

      @order.save_payment_id(@payment_intent.id)
      @order.mark_as_paid # Update the order status to "paid"
      session[:order_id] = nil
    else
      # Handle the case where the order is not found
    end
  end

  def cancel
    # Something went wrong with the payment :(
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
