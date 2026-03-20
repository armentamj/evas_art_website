# config/routes.rb
Rails.application.routes.draw do
  root to: "home#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

  resources :artworks
  get "/:slug", to: "artworks#index", as: :category
end
