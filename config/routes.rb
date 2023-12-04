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
end
