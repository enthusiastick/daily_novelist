Rails.application.routes.draw do

  root "pages#index"

  get "auth/:provider/callback", to: "identities#create"

  get "sign-in", to: "sessions#new", as: :sign_in
  post "sign-in", to: "sessions#create"
  delete "sign-out", to: "sessions#destroy"
  get "sign-up", to: "identities#new", as: :sign_up

  resources :account_confirmations, only: [:edit]
  resources :auth, only: [:show]
  resources :password_resets, only: [:create, :edit, :new, :update]
  resources :users, only: [:create, :edit, :update] do
    collection do
      get "sign-in", to: "user_sessions#new", as: :sign_in
      get "sign-up", to: "users#new", as: :sign_up
    end
    resources :identities, only: [:edit, :update]
  end

end
