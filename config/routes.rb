# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :stations
  end

  root to: "welcome#index"

  post "fetch", to: "welcome#fetch", as: :fetch_all
end
