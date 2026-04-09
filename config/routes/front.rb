scope module: :front do
  root "home#index"
  get :terms, to: "home#terms"
  get :inquiry, to: "home#inquiry"
  post :inquiry, to: "home#create_inquiry"
  resources :sessions, only: [ :new, :create, :destroy ]
  resources :tablewares do
    collection do
      get :search
    end
  end
  resources :places, only: [ :index, :show ]
end
