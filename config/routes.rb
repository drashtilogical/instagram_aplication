Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users, controllers: { sessions: 'users/sessions' }

  root "homes#index"
  resources :homes, only: [:show]
  
  resources :photos do
    member do
      post 'like'
      post 'unlike'
    end
  end
  resources :users       
  resources :homes, only: [:index, :show] do
    member do
      post 'follow'
      delete 'unfollow'
      delete 'cancel_request'
      patch 'accept_request'
      delete 'reject_request'
    end
  end
end
