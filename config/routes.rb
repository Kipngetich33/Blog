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
  post "/articles/:article_id/events/email_event" => "events#email_event"

end
