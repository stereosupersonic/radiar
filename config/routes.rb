require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  Sidekiq::Web.app_url = "/"

  namespace :admin do
    resources :stations
    resources :fetch_track_infos, only: :update
    resources :ignore_tracks, only: :update
    resources :track_infos, only: %i[edit update]
    resources :events, only: %i[index show]
    resources :tracks, only: [] do
      resources :events, only: %i[index show], controller: "track_events"
    end
  end
  resources :tracks, only: %i[index show]
  resources :track_infos, only: %i[index show]
  root to: "welcome#index"
end
