namespace :owner do
  root "home#index"
  resources :sessions, only: [ :new, :create ]
  resource :store, only: [ :show, :edit, :update ]
  resources :users, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
  resources :tablewares do
    member do
      post :image_upload
    end
    delete "image_destroy/:image_id", action: :image_destroy, as: :image_destroy
  end
  resources :categories do
    resources :items, module: :categories
  end
  resources :inquiries, only: [ :index, :show ]
  resources :places do
    collection do
      patch :update_floor_map
    end
  end
end
