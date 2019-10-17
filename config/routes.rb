Rails.application.routes.draw do


  root "levels#show"
  get "levels/:id", to: "levels#show", as: "level"
  post "levels/:id", to: 'levels#store'
  get "levels/:id/results", to: 'levels#results', as: "level_results"
  get "remove_step/:index", to: "levels#remove_step", as: "remove_step"
  
end
