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

  resources :pools, only: [] do
    resource :possibilities, only: [:show]
  end

  resources :brackets, only: [:edit, :update, :destroy] do
    resources :picks, only: [:update]
  end

  resources :tournaments, only: [:edit, :update]

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
  get "/pools/:pool_id/rules" => "pages#home", as: :rules_pool
  get "/pools/:pool_id/payments" => "pages#home", as: :payments_pool
  get "/pools/:pool_id/games" => "pages#home", as: :pool_games
  get "/pools/invite_code" => "pages#home", as: :invite_code
  get "/user" => "pages#home", as: :profile

  get "/*path" => "pages#home"
end
