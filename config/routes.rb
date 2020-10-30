# frozen_string_literal: true

Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :stations
    resources :events, only: %i[index show]
    resources :tracks, only: [] do
      resources :events, only: %i[index show], controller: "track_events"
    end
  end
  resources :tracks, only: :index
  root to: "welcome#index"
end
