PoolMadness::Application.routes.draw do

  root to: "home#index"

  namespace :admin do
    resources :brackets do
      member do
        patch :promise_to_pay
        patch :mark_paid
      end
      collection do
        get :update_outcomes
      end
    end
  end

  match "/subscribe", to: "home#subscribe", via: :get, as: "subscribe"
  match "/payments", to: "home#payments", via: :get, as: "payments"
  match "/rules", to: "home#rules", via: :get, as: "rules"
  match "/final_possibilities", via: :get, to: "home#whatif", as: "possible"

  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_up: "signup" }

  resources :users do
    resources :stripes, only: [:index]
  end

  resources :picks, only: [:update]

  resources :brackets, except: [:new] do
    get "printable", on: :member
    get "current_user_bracket_ids", on: :collection
    resources :stripes, only: [:create]
  end

  resources :games
end
