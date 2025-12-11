Rails.application.routes.draw do
  root "dashboard#index"
  
  get "dashboard", to: "dashboard#index"

  # Authentication routes
  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :contacts
  resources :audiences do
    member do
      post :sync_to_meta
      post :sync_to_linkedin
      get :add_contacts
      post :add_contacts
      delete "remove_contact/:contact_id", action: :remove_contact, as: :remove_contact
    end
  end

  resources :campaigns do
    member do
      post :fetch_insights
      post :fetch_linkedin_insights
      post :push_to_linkedin
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
