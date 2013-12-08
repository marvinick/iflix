Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'home', to: "videos#index"

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :users, only: [:show]
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy]
  get 'ui(/:action)', controller: 'ui'

  resources :categories, only: [:index, :show]
  resources :queue_items, only: [:index, :create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'my_queue', to: 'queue_items#index'

  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: 'sessions#destroy'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
