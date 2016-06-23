require "sidekiq/web"

PoolMadness::Application.routes.draw do
  if defined?(GraphiQL::Rails::Engine)
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_up: "signup" }

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "home#index"

  resource :user, only: [:show, :edit, :update], as: :profile

  match "pools/join", to: "pools#join", via: :post, as: "join_pool"
  match "pools/invite_code", to: "pools#invite_code", via: :get, as: "invite_code"

  resources :pools, only: [] do
    member do
      get :rules
      get :payments
    end

    resources :brackets, only: [:create]
    resources :games, only: [:index]
    resource :possibilities, only: [:show]
  end

  resources :brackets, except: [:index, :create] do
    resources :picks, only: [:update]
  end

  resources :charges, only: [:create]

  resources :tournaments, only: [:edit, :update] do
    resources :games, only: [:index]
  end

  namespace :admin do
    resources :pools, only: [] do
      resources :brackets, only: [:index]
    end

    resources :brackets, only: [] do
      patch :mark_paid, on: :member
    end
  end

  post "/graphql" => "pages#graphql"
  # root to: "pages#home"

  get "/pools" => "pages#home", as: :pools
  get "/pools/:pool_id" => "pages#home", as: :pool

  get "/*path" => "pages#home"
end
