PoolMadness::Application.routes.draw do
  authenticated :user do
    root :to => 'brackets#index'
  end

  root :to => "home#index"

  devise_for :users

  resources :users
  resources :picks, :only => [:update]
  resources :brackets, :except => [:new, :update]
end