RushJobMongoid::Engine.routes.draw do
  root 'dashboard#index'
  delete '/dashboard', to: 'dashboard#destroy'
  patch '/settings', to: 'settings#update'

  resources :rush_jobs, only: %i[index edit update]
end
