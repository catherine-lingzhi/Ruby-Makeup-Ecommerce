class ProductsController < ApplicationController
  def index
    @products = case params[:filter]
                when "on_sale"
                  Product.where(on_sale: true)
                when "new"
                  Product.where("created_at >= ?", 3.days.ago)
                when "recently_updated"
                  Product.where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago)
                else
                  Product.all
                end.page(params[:page]).per(15)
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    @keywords = params[:keywords]
    @category_id = params[:category_id]

    @products = Product.all

    @products = @products.where("name LIKE ?", "%#{@keywords}%") if @keywords.present?
    return unless @category_id.present? && @category_id != "All"

    @products = @products.where(category_id: @category_id)
  end
end
