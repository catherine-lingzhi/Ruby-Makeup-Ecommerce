class ChangeScaleForPriceInProducts < ActiveRecord::Migration[7.0]
  def self.up
    change_table :products do |t|
      t.change :price, :decimal, precision: 20, scale: 2
    end
  end
  def self.down
    change_table :products do |t|
      t.change :price, :decimal
    end
  end
end
