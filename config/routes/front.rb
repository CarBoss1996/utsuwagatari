scope module: :front do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :tablewares do
    collection do
      get :search
    end
  end
  resources :places, only: [ :index, :show ]
end
