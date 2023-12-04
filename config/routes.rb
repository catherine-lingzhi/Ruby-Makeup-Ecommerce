Rails.application.routes.draw do
  resources :provinces
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root "products#index"

  resources :orders

  resources :products, only: %i[index show] do
    collection do
      get "search", to: "products#search"
    end
  end
  resources :cart do
    post "update_quantity", on: :member
  end
  resources :categories, only: %i[index show]

  scope "/checkout" do
    post "create", to: "checkout#create", as: "checkout_create"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end
end
