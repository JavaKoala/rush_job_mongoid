module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @rush_jobs = RushJob.all
    end
  end
end
