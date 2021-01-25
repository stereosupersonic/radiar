

Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :stations
    resources :ignore_tracks, only: :update
    resources :track_infos, only: %i[edit update]
    resources :events, only: %i[index show]
    resources :tracks, only: [] do
      resources :events, only: %i[index show], controller: "track_events"
    end
  end
  resources :tracks, only: %i[index show]
  root to: "welcome#index"
end
