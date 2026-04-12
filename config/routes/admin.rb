namespace :admin do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :stores do
    resources :users do
      collection do
        get :confirm
      end
    end
  end
  resources :inquiries, only: [ :index, :show, :update ] do
    resources :answers, only: [ :create, :destroy ]
  end
end
