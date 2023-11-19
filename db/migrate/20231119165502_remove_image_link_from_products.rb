class RemoveImageLinkFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :image_link, :string
  end
end
