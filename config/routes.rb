Rails.application.routes.draw do
  resources :recipes, only: [:index, :show]
  root 'recipes#index'
end
