class ApplicationController < ActionController::Base
  before_action :initialize_session
  helper_method :cart

  private

  def initialize_session
    session[:shopping_cart] ||= [] # empth array of products IDs
  end

  def cart
    # lookup a product based upon a series of ids
    Product.where(id: session[:shopping_cart])
  end
end
