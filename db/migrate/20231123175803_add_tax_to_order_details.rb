class AddTaxToOrderDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :order_details, :tax, :decimal
  end
end
