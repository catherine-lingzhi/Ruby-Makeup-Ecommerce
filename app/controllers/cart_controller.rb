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

    flash[:notice] = "+ #{quantity} #{product.name}(s) added to cart...Check your Cart"
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
    redirect_to cart_path
  end

  # POST /cart/:id/update_quantity
  def update_quantity
    id = params[:id].to_i
    quantity = params[:quantity].to_i

    existing_item = session[:shopping_cart].find { |item| item["id"] == id }

    return unless existing_item

    existing_item["quantity"] = quantity

    redirect_to cart_path
  end

  def show
    @cart = cart
  end
end
