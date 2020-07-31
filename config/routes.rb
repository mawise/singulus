# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq_unique_jobs/web'

Rails.application.routes.draw do
  # Only allow login via the web interface, as well as the unlock endpoint.
  devise_for :users, only: %i[sessions], path: '',
                     path_names: { sign_in: 'login', sign_out: 'logout' }
  get '/unlock', to: 'devise/unlocks#show', as: :user_unlock

  use_doorkeeper

  get '/micropub', to: 'micropub_queries#show', as: :micropub, format: false
  post '/micropub', to: 'micropub#create', format: false
  post '/micropub/media', to: 'micropub_media#create', as: :micropub_media, format: false

  scope format: false do
    resources :posts
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'home#index'
end
