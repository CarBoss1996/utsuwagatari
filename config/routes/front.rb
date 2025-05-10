scope module: :front do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :tablewares do
    post :search
  end
end
