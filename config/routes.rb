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

  # add a post method to handle post requests
  post "/articles/:article_id/event/email_event" => "events#email_event"

  namespace :api do
    namespace :v1 do
      # add url endpoint paths
      resources :events, only: [:index]
      post "events/email_event", to: "events#email_event"

      # get "urls", to: "urls#index"
      # get "urls:/:id", to: "urls#show" 
      # post "urls", to: "urls#create"
      # post "urls/redirect", to: "urls#redirect"
      # # add statistic endpoint paths
      # get "statistics", to: "statistics#index"
      # get "statistics/:id", to: "statistics#show"
      # post "statistics", to: "statistics#create" 
    end
  end
end


