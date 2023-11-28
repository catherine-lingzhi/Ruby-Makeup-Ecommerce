class ApplicationController < ActionController::Base
  before_action :initialize_session
  before_action :update_allowed_parameters, if: :devise_controller?
  helper_method :cart

  private

  def initialize_session
    session[:shopping_cart] ||= [] # empty array of product IDs
  end

  def cart
    # lookup a product based upon a series of IDs
    Product.where(id: session[:shopping_cart])
  end

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :address, :email, :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :address, :email, :current_password)
    end
  end
end
