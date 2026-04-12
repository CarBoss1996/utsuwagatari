scope module: :front do
  root "home#index"
  get :terms, to: "home#terms"
  resources :inquiries, only: [ :index, :new, :create ] do
    collection do
      post :confirm
    end
    member do
      patch :read
    end
  end
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :tablewares do
    collection do
      get :search
    end
  end
  resources :places, only: [ :index, :show ]
end
