require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :data_points, only: [:index]
  resources :data_sources
  resources :golfers, only: [:index, :show]
  resources :tournaments
end
