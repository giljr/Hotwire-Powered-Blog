Rails.application.routes.draw do
  # This sets up nested routes for comments under posts.
  # You can verify the routes by running rails routes in the terminal. 
  # Look for:
  # rails routes | grep new_post_comment
  #   Prefix            Verb   URI Pattern                             Controller#Action
  # ----------------    ----   --------------------------------------  -----------------
  # new_post_comment     GET   /posts/:post_id/comments/new(.:format)  comments#new
  #
  resources :posts do
    resources :comments
  end

  get "about", to: "about#index"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  delete "sign_out", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check

  root "main#index"
end
