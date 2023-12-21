RushJobMongoid::Engine.routes.draw do
  root 'dashboard#index'
  get '/rush_jobs', to: 'rush_jobs#index'
  patch '/settings', to: 'settings#update'
end
