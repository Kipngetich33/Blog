Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "articles#index" 

  # resources :articles

  resources :articles do
    resources :events
  end

  namespace :api do
    namespace :v1 do
      # add url endpoint paths
      resources :events, only: [:index]
      post "events/email_event", to: "events#email_event"
    end
  end

  # add dashboard url for events
  get "/events/events_dashboard", to: "events#events_dashboard"
end


