namespace :owner do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resources :tablewares do
    member do
      post :image_upload
    end
    delete "image_destroy/:image_id", action: :image_destroy, as: :image_destroy
  end
  resources :categories do
    resources :items, module: :categories
  end
  resources :places
end
