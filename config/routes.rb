Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "decomojis#index"

  get 'grid', controller: :decomojis
  get 'list', controller: :decomojis

  resources :decomojis do
    resources :aliases, except: [:index, :new, :show]

    collection do
      resources :bulk_add_tag, only: [:new, :create]
    end

    member do
      post 'add_tag'
      delete 'remove_tag/:tag_id', to: 'decomojis#remove_tag', as: 'remove_tag'
    end

    resource :tags, only: [:update], controller: 'decomojis/tags'

    resource :list_tags, only: [:show, :edit, :create], controller: 'decomojis/list_tags'
    resources :list_tags, only: [:destroy], controller: 'decomojis/list_tags'
  end

  resources :batches, only: [:new, :create] do
    collection do
      post 'confirm'
    end
  end

  resources :checks do
    resources :decomoji_checks, only: [:update]

    member do
      get 'review'
    end
  end

  resources :tags, except: [:new, :show]

  resources :versions, except: [:new, :show]

  resources :colors, only: [:index]
end
