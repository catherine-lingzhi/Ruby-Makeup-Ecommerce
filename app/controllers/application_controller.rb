class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :update_allowed_parameters, if: :devise_controller?
  helper_method :cart
  before_action :authenticate_user!

  private

  def initialize_session
    session[:shopping_cart] ||= [] # empty array of product IDs
  end

  def cart
    cart_items = []
    total_price = 0

    session[:shopping_cart].each do |item|
      product = Product.find_by(id: item["id"])

      if product
        quantity = item["quantity"]
        subtotal = product.price * quantity
        total_price += subtotal
        cart_items << { "product" => product, "quantity" => quantity, "subtotal" => subtotal }
      else
        Rails.logger.error("Product with ID #{item['id']} not found.")
      end
    end

    { "cart_items" => cart_items, "total_price" => total_price }
  end

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :address, :province_id, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :address, :province_id, :email, :current_password)
    end
  end
end
