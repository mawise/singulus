# frozen_string_literal: true

Rails.application.routes.draw do
  # Only allow login via the web interface, as well as the unlock endpoint.
  devise_for :users, only: %i[sessions], path: '',
                     path_names: { sign_in: 'login', sign_out: 'logout' }
  get '/unlock', to: 'devise/unlocks#show', as: :user_unlock

  use_doorkeeper

  get '/micropub', to: 'micropub#show', as: :micropub, format: false
  post '/micropub', to: 'micropub#create', format: false

  root to: 'home#index'
end
