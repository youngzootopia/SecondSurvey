Rails.application.routes.draw do
  get 'home/index', to: "home#index"
  
  #...
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # sign up
  get '/signup', to: "users#new"
  post '/signup', to: "users#create"
  resources :users
end
