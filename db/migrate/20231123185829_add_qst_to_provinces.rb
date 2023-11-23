class AddQstToProvinces < ActiveRecord::Migration[7.0]
  def change
    add_column :provinces, :QST, :decimal
  end
end
