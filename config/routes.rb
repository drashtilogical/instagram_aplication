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
end
