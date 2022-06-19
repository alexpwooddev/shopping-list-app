Rails.application.routes.draw do
  get 'saved_qrs/show'
  get 'saved_qrs/edit'
  get 'saved_qrs/destroy'
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
end
