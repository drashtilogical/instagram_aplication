Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users, controllers: { sessions: 'users/sessions' }

  root "homes#index"
  
  resources :photos do
    member do
      post 'like'
      post 'unlike'
    end
    resources :comments, only: [:create]
  end
  resources :users     

  resources :homes, only: [:index, :show] do
    member do
      post 'follow'
      delete 'unfollow'
      post 'send_request'
      delete 'cancel_request'
      patch 'accept_request'
      delete 'reject_request'
    end
  end
end
