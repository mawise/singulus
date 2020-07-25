# frozen_string_literal: true

Rails.application.routes.draw do
  # Only allow login via the web interface, as well as the unlock endpoint.
  devise_scope :user do
    get '/login', to: 'devise/sessions#new', as: :new_user_session
    post '/login', to: 'devise/sessions#create', as: :user_session
    delete '/logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    get '/unlock', to: 'devise/unlocks#show', as: :user_unlock
  end

  root to: 'home#index'
end
