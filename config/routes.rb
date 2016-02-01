require "sidekiq/web"

PoolMadness::Application.routes.draw do
  root to: "home#index"

  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_up: "signup" }

  resource :user, only: [:show, :edit, :update], as: :profile

  match "pools/join", to: "pools#join", via: :post, as: "join_pool"
  match "pools/invite_code", to: "pools#invite_code", via: :get, as: "invite_code"

  resources :pools, only: [:index, :show] do
    member do
      get :rules
      get :payments
    end

    resources :brackets, only: [:index, :create]
    resources :games, only: [:index]
  end

  resources :brackets, except: [:index, :create] do
    resources :picks, only: [:update]
  end

  resources :charges, only: [:create]

  resources :tournaments, only: [:edit, :update] do
    resources :games, only: [:index]
  end

  namespace :admin do
    resources :tournaments, only: [] do
      patch :update_bracket_scores, on: :member
    end

    resources :pools, only: [] do
      resources :brackets, only: [:index]
    end

    resources :brackets, only: [] do
      patch :mark_paid, on: :member
    end
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
