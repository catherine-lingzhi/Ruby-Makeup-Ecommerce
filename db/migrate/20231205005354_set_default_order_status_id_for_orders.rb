class SetDefaultOrderStatusIdForOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :order_status_id, from: nil, to: 1
  end
end
