namespace :owner do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :tablewares
  resources :categories do
    resources :items, module: :categories
  end
end
