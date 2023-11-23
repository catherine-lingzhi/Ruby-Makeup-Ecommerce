class RemoveProvinceFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :province, null: false, foreign_key: true
  end
end
