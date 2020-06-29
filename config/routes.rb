# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :stations
  end

  root to: "welcome#index"
end
