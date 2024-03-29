Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root "pages#my_lists", as: :authenticated_root
  end
  root 'pages#home'

  get 'lists/:id', to: 'pages#list', as: :list
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :lists, only: [:index, :show, :create, :update, :destroy] do
        resources :list_items, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  resources :saved_qrs, only: [:index, :show, :edit, :update, :destroy]
  resources :favourited_lists, only: [:index, :create, :destroy]
  get 'stats', to: 'stats#index'
  get 'published_lists', to: 'published_lists#index'

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'
end
