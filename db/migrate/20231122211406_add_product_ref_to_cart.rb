class AddProductRefToCart < ActiveRecord::Migration[7.0]
  def change
    add_reference :carts, :product, null: false, foreign_key: true
  end
end
