class AddProvinceRefToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_reference :profiles, :province, null: false, foreign_key: true
  end
end
