Rails.application.routes.draw do
  get 'sessions/new'

  get 'home/index', to: 'sessions#new'
  
  #...
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # sign up
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
end
