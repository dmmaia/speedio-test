Rails.application.routes.draw do
  resources :automations
  resources :companies
  resources :users, only: [:create, :index, :update]
  resources :auth
  resources :sessions, only: [:create]
  
  post '/users-webhook', to: "users#webhook"
  get 'users-generate-link', to: "users#show_connect_link"

  get "up" => "rails/health#show", as: :rails_health_check
  post '/authorization', to: "sessions#authorization"
  post '/authenticate', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  # Defines the root path route ("/")
  # root "posts#index"
end
