Rails.application.routes.draw do
  root "pages#home"

  devise_for :users,
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               edit: "profile",
               sign_up: "registration",
             },
             controllers: {
               omniauth_callbacks: "omniauth_callbacks",
               registrations: "registrations",
             }

  resources :users, only: :show

  scope module: :current_user do
    post  "verify_phone_number"
    patch "update_phone_number"
  end

  namespace :open_hours do
    resources :week_days, only: %i[create update destroy]
    resources :special_days, only: %i[create update destroy]
  end

  resources :reservations, only: :index

  resources :rooms, except: [:edit] do
    member do
      get "preload"
      get "preview"
      get "availability"
    end

    resources :photos, only: %i[create destroy]
    resources :reservations, only: :create

    # resources :calendars
  end

  resources :guest_reviews, only: %i[create destroy]
  resources :host_reviews, only: %i[create destroy]
  resources :subscriptions, only: %i[index new create]

  get "search" => "pages#search"
  get "why" => "pages#why"
  get "how-it-works" => "pages#how_it_works"
  get "faq" => "pages#faq"
  get "about" => "pages#about"
  get "privacy" => "pages#privacy"
  get "terms" => "pages#terms"

  # resources :revenues, only: [:index]

  resources :conversations, only: %i[index create] do
    resources :messages, only: %i[index create]
  end

  resources :messages, only: :destroy

  # get '/host_calendar' => "calendars#host"

  get "/notification_settings" => "settings#edit"
  post "/notification_settings" => "settings#update"

  get "/notifications" => "notifications#index"

  mount ActionCable.server => "/cable"

  # Supplier
  namespace :suppliers do
    resources :reservations, only: :index do
      member do
        post :approve
        post :decline
      end
    end

    resources :rooms, only: %i[index new create update] do
      member do
        get :description
        get :amenities
        get :pricing
        get :location
        get "open_hours"
        get :photo_upload
      end
    end

    get :dashboard, to: "dashboard#index"
  end

  # Admin Panel
  namespace :panel do
    root "users#index"

    get    "/login"  => "sessions#new"
    post   "/login"  => "sessions#create"
    delete "/logout" => "sessions#destroy"

    resources :admins, only: %i[index new create edit update destroy]
    resources :featured_clinics, only: [:index]
    resources :clinics, only: [:update]
    resources :plans, only: %i[index edit update]

    resources :users, only: [:index] do
      resources :clinics, only: [:index]
    end
  end

  # Errors
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"
end
