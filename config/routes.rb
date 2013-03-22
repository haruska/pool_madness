PoolMadness::Application.routes.draw do
  authenticated :user do
    root :to => 'brackets#index'
  end

  namespace :admin do
    resources :brackets do
      member do
        put :promise_to_pay
        put :mark_paid
      end
    end
  end

  root :to => "home#index"
  match '/subscribe', :to => "home#subscribe", :as => 'subscribe'
  match '/payments', :to => "home#payments", :as => 'payments'
  match '/rules', :to => "home#rules", :as =>'rules'

  devise_for :users, :path => 'auth', :path_names => {:sign_in => 'login', :sign_up => 'signup'}

  resources :users do
    resources :charges, :only => [:index]
  end

  resources :charges, :only => [:create]

  resources :picks, :only => [:update]

  resources :brackets, :except => [:new] do
    get 'printable', :on => :member
    get 'current_user_bracket_ids', :on => :collection
    resources :stripes, :only => [:create]
  end

  resources :games
end