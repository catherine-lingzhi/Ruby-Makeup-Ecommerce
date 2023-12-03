class CheckoutController < ApplicationController
  # POST /checkout/create
  # a product id will be in the params hash params[:product_id]
  def create
    # Load up the product the user wishes to purchase from the product model:

    product = Product.find(params[:product_id])

    # DONT EVEN BOTHER CONTINUING IF SOMEONE IS MESSING WITH US
    if product.nil?
      redirect_to root_path
      return
    end

    # Establish a connection with Stripe and then redirect the user to the payment screen.

    # this call here, will have our server connect to stripe!
    # strip gem access to private key to setup the session behind the scenes
    # one of th bits of info is the INTERNAL ID for the session
    # so after this we need to provide that ID back to stripe for authentication.
    # That step happens in the JAVASCRIPT
    @session = Stripe::Checkout::Session.create(
      # went to stripe API, looked up sessions, figured it all out..
      payment_method_types: ["card"],
      mode:                 "payment",
      success_url:          checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           checkout_cancel_url,

      line_items:           [
        {
          price_data: {
            currency:     "cad",
            product_data: {
              name:        product.name,
              description: product.description
            },
            unit_amount:  product.price_cents
          },
          quantity:   1
        },
        {
          price_data: {
            currency:     "cad",
            product_data: {
              name:        "GST",
              description: "Goods and Services Tax"
            },
            unit_amount:  (product.price_cents * 0.05).to_i
          },
          quantity:   1
        }
      ]
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
