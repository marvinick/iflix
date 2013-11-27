Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: "videos#index"
  get 'show', to: "videos#show"

  resources :videos, only: [:show]
  resources :categories, only: [:index, :show]
end
