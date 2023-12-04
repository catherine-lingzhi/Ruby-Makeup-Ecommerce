class CheckoutController < ApplicationController
  # POST /checkout/create
  # a product id will be in the params hash params[:product_id]
  def create
    # Load up the existing order and its order details:
    @order = Order.find(params[:order_id])

    # Establish a connection with Stripe and then redirect the user to the payment screen.
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode:                 "payment",
      success_url:          checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           checkout_cancel_url,

      line_items:           @order.line_items_for_stripe
    )

    redirect_to @session.url, allow_other_host: true
  end

  def success
    # We took the customer's money!
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
  end

  def cancel
    # Something went wrong with the payment :(
  end
end
