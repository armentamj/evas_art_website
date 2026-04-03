# config/routes.rb
Rails.application.routes.draw do
  get "pages/impressum" # Keep outside if you don't want /en/ or /de/ in front of it

  scope "(:locale)", locale: /en|de/ do
    root to: "home#index"

    # Artwork member for deleting an image and adding one while still on the artwork's _form and also showing the images.
    resources :artworks do
      member do
        delete :delete_image
      end
    end

    get "impressum", to: "pages#impressum", as: :impressum
    get "contact", to: "pages#contact", as: :contact
    get "up" => "rails/health#show", as: :rails_health_check

    resource :session, only: [ :new, :create, :destroy ]
    resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

    get "/:slug", to: "artworks#index", as: :category,
    constraints: { slug: /abstract-paintings|flowers-and-still-lifes|tiny-art/ }
  end
end
