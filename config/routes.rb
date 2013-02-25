PoolMadness::Application.routes.draw do
  authenticated :user do
    root :to => 'brackets#index'
  end

  root :to => "home#index"

  devise_for :users, :path => 'auth', :path_names => {:sign_in => 'login', :sign_up => 'signup'}

  resources :users
  resources :picks, :only => [:update]
  resources :brackets, :except => [:new, :update]
end