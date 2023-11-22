class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :order_status
      t.decimal :subtotal

      t.timestamps
    end
  end
end
