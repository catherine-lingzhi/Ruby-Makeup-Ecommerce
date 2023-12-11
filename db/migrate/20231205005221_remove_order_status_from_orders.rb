class RemoveOrderStatusFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :order_status
  end
end
