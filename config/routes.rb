Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
    }

  root "static_pages#top"

  resources :diagnoses, only: [ :new, :create ]
  get "diagnoses/result/:token", to: "diagnoses#show", as: :diagnosis_result

  resources :posts, only: [ :index, :new, :create, :edit, :show, :update, :destroy ]
  resources :products, only: [ :index ]
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
