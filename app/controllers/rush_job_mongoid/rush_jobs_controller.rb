module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @rush_jobs = RushJob.locked_by_desc
    end
  end
end
