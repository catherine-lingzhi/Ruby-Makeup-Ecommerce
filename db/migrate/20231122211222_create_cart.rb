class CreateCart < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.decimal :subtotal

      t.timestamps
    end
  end
end
