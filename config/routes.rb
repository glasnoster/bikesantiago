Rails.application.routes.draw do
  namespace :api do
    resources :stations, only: :index
    resource :usage, only: :show
  end
end
