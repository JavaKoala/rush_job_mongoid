Rails.application.routes.draw do
  mount RushJobMongoid::Engine => "/rush_job_mongoid"
end
