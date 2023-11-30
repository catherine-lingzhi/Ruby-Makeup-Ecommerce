class CartController < ApplicationController
  # POST /cart
  def create
    logger.debug("Adding #{params[:id]} to cart with quantity #{params[:quantity]}")

    id = params[:id].to_i
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    product = Product.find_by(id:)

    # Check if the product is already in the cart
    existing_item = session[:shopping_cart].find { |item| item["id"] == id }

    if existing_item
      # Product is already in the cart, update the quantity
      existing_item["quantity"] += quantity
    else
      # Product is not in the cart, add it with the specified quantity
      session[:shopping_cart] << { "id"       => id,
                                   "quantity" => quantity }
    end

    flash[:notice] = "+ #{quantity} #{product.name}(s) added to cart..."
    redirect_to root_path
  end

  # DELETE /cart/:id
  def destroy
    logger.debug("removing #{params[:id]} from cart.")
    id = params[:id].to_i

    if (index = session[:shopping_cart].find_index { |item| item["id"] == id })
      session[:shopping_cart].delete_at(index)
    end

    # TODO: - Add notification ...
    redirect_to root_path
  end

  def show
    # Assign the shopping cart contents to an instance variable
    @cart = cart
  end
end
