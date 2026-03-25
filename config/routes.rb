# config/routes.rb
Rails.application.routes.draw do
  get "pages/impressum"
  scope "(:locale)", locale: /en|de/ do
    root to: "home#index"
    get "impressum", to: "pages#impressum", as: :impressum
    get "up" => "rails/health#show", as: :rails_health_check

    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

    resources :artworks
    get "/:slug", to: "artworks#index", as: :category
  end
end
