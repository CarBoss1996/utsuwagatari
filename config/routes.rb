Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#index"

  namespace :admin do
    resources :sessions, only: [ :new, :create ]
    resources :stores
  end

  resources :users, only: [ :new, :create ] do
    collection do
      get :confirm
    end
  end

  resources :sessions, only: [ :new, :create, :destroy ]
end
