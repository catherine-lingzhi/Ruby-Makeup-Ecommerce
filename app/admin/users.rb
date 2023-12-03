ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at,
                :remember_created_at, :first_name, :last_name, :address, :province_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :address, :province_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  ActiveAdmin.register User do
    form do |f|
      f.inputs "User Details" do
        f.input :first_name
        f.input :last_name
        f.input :address
        f.input :province_id, as: :select, collection: Province.all.map { |p| [p.name, p.id] }
        f.input :email
      end
      f.actions
    end
  end
end
