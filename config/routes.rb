Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "decomojis#index"

  #get "/decomojis/:id", to: "decomojis#show"
  resources :decomojis, except: [:index] do
    resources :aliases, only: [:create, :destroy]

    member do
      post 'add_tag'
      delete 'remove_tag/:tag_id', to: 'decomojis#remove_tag', as: 'remove_tag'
    end
  end
  get "/decomojis", to: redirect("/")

  resources :tags, except: [:new, :show]

  resources :versions, except: [:new, :show]
end
