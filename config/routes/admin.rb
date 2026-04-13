namespace :admin do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :users, only: [ :index, :show, :edit, :update, :destroy ]
  resources :stores do
    resources :users do
      collection do
        get :confirm
      end
    end
  end
  resources :tablewares, only: [ :index, :show ]
  resources :inquiries, only: [ :index, :show, :update ] do
    resources :answers, only: [ :create, :destroy ]
  end
end
