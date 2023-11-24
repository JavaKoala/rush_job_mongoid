module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @rush_jobs = RushJob.locked_by_desc.paginate(1)
    end
  end
end
