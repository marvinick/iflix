Myflix::Application.routes.draw do
  root to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: "videos#index"
  get 'show', to: "videos#show"

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
  end
  resources :categories, only: [:index, :show]
end
