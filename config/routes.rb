# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :guests, only: %i[index] do
    collection do
      get '/reservations', action: :reservations, to: 'guests#reservations'
    end
  end

  resources :reservations, only: %i[index create]
end
