namespace :owner do
  root "home#index"
  resources :sessions, only: [ :new, :create]
  resources :tablewares
end