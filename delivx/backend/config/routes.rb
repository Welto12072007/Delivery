Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      # Users routes
      resources :users, only: [:index, :show, :create, :update, :destroy]
      
      # Restaurants routes  
      resources :restaurants, only: [:index, :show, :create, :update, :destroy] do
        resources :foods, only: [:index, :show, :create, :update, :destroy]
      end
      
      # Foods routes (global)
      resources :foods, only: [:index, :show, :create, :update, :destroy]
      
      # Authentication routes
      post '/auth/login', to: 'auth#login'
      post '/auth/register', to: 'auth#register'
      delete '/auth/logout', to: 'auth#logout'
      
      # Orders routes
      resources :orders, only: [:index, :show, :create, :update]
      
      # Categories routes
      resources :categories, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
