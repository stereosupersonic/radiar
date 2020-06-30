# frozen_string_literal: true

Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :stations
  end

  root to: "welcome#index"

  post "fetch", to: "welcome#fetch", as: :fetch_all
end
