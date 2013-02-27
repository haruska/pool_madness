PoolMadness::Application.routes.draw do
  authenticated :user do
    root :to => 'brackets#index'
  end

  root :to => "home#index"

  devise_for :users, :path => 'auth', :path_names => {:sign_in => 'login', :sign_up => 'signup'}

  resources :users do
    resources :charges, :only => [:index]
  end

  resources :charges, :only => [:create]

  resources :picks, :only => [:update]
  resources :brackets, :except => [:new]
end