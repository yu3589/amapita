Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
    }

  root "static_pages#top"

  resource :profile, only: %i[edit show update]

  resources :users, only: %i[show]

  resources :diagnoses, only: %i[new create]
  get "diagnoses/result/:token", to: "diagnoses#show", as: :diagnosis_result

  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    collection do
      get :search_products
    end
  end

  resources :likes, only: %i[create destroy]

  resources :notifications, only: %i[index update] do
    collection do
      patch :mark_all_as_read
    end
  end

  resources :products, only: %i[index show]

  resources :bookmarks, only: %i[index create destroy]

  resources :categories, only: %i[index show], param: :slug do
    resources :products, only: %i[show]
  end

  namespace :admin do
    root "dashboards#index"

    get "login", to: "user_sessions#new"
    post "login", to: "user_sessions#create"
    delete "logout", to: "user_sessions#destroy"

    resource :dashboard, only: %i[index]
    resources :products
    resources :posts, only: %i[index destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
