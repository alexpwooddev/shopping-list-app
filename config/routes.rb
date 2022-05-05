Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root "pages#my_lists", as: :authenticated_root
    get 'lists/:id', to: 'pages#list', as: :list
  end
  root 'pages#home'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :lists, only: [:index, :show, :create, :update, :destroy] do
        resources :list_items, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
