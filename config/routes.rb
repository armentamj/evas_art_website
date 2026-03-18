# config/routes.rb

Rails.application.routes.draw do
  # Category filtering routes (pretty URLs like /abstract-paintings)
  get "/:slug", to: "artworks#index", as: :category

  # Main resource routes for artworks
  resources :artworks, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]

  # Authentication related routes
  resource :session, only: [ :new, :create, :destroy ]   # login / logout
  # If you're using password reset functionality:
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

  # Home / landing page
  root to: "home#index"

  # Optional: you can keep or remove this – most people remove it when they have root defined
  # get "home/index"   # ← usually redundant with root

  # Rails health check (useful for hosting platforms, monitoring, load balancers)
  get "up" => "rails/health#show", as: :rails_health_check

  # Optional: Progressive Web App manifest & service worker (uncomment if you use PWA)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Add future resources here (e.g. users, admin namespace, contact form, etc.)
end
