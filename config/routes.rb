RushJobMongoid::Engine.routes.draw do
  root 'dashboard#index'
  delete '/dashboard', to: 'dashboard#destroy'
  get '/rush_jobs', to: 'rush_jobs#index'
  patch '/settings', to: 'settings#update'
end
