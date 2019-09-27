Rails.application.routes.draw do


  root "levels#show"
  get "levels/:id", to: "levels#show", as: "level"
  post "levels/:id", to: 'levels#store'
  get "levels/:id/results", to: 'levels#results', as: "level_results"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
