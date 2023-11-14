Rails.application.routes.draw do
  root "products#index"

  resources :products, only: %i[index show] do
    collection do
      get "search", to: "products#search"
    end
  end

  resources :categories, only: %i[index show]
end
