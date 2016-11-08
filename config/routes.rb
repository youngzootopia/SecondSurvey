Rails.application.routes.draw do
  resources :shot_infos
  resources :clists
  
  get '/test',						 to: 'response#test'
  
  # contact static page
  get '/contact',					 to: 'home#contact'

  #...
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new'
  get	 'home/index',				 to: 'sessions#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # sign up, login, logout... etc
  get	 '/signup',					 to: 'users#new'
  post	 '/signup',					 to: 'users#create'
  get	 '/users/edit',				 to: 'users#edit'
  post	 '/users/edit',				 to: 'users#update'
  get	 '/users/password',			 to: 'users#password_edit'
  post	 '/users/password',			 to: 'users#password_update'
  get	 'sessions/new'
  get    '/login', 					 to: 'sessions#new'
  post   '/login',					 to: 'sessions#create'
  delete '/logout',					 to: 'sessions#destroy'
  get	 '/filtering',				 to: 'filterings#new'
  post	 '/filtering',				 to: 'filterings#create'
  
  # 1차 설문
  get	 '/first',	 to: 'first#get_page'
  get	 '/get_first_infomation',	 to: 'first#get_json'
  
end
