Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: %i[index show] do
    collection do
      get "search", to: "products#search"
    end
  end

  resources :categories, only: %i[index show]
end
