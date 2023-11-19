ActiveAdmin.register Product do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :price, :image_link, :description, :category_id, :image, :on_sale
  #
  # or
  #
  # permit_params do
  #   permitted = %i[name price image_link description category_id]
  #   permitted << :other if params[:action] == "create" && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs "Product Details" do
      f.input :category_id, as: :select, collection: Category.all.map { |c|
        [c.name, c.id]
      }, include_blank: false
      f.input :name
      f.input :price
      f.input :description
      f.input :image, as:   :file,
                      # hint: f.object.image.present? ? image_tag(f.object.image.variant(resize_to_limit: [500, 500])) : ""
                      hint: f.object.image.present? ? image_tag(f.object.image, size: "150x150") : ""
      f.input :on_sale
    end
    f.actions
  end
end
