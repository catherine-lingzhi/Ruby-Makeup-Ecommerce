class ProductsController < ApplicationController
  def index
    @products = Product.all.page(params[:page]).per(15)
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    @keywords = params[:keywords]
    @category_id = params[:category_id]

    @products = Product.all

    @products = @products.where("name LIKE ?", "%#{@keywords}%") if @keywords.present?
    return unless @category_id.present? && @category_id != "All Categories"

    @products = @products.where(category_id: @category_id)
  end
end
