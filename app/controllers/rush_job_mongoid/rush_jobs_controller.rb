module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @page = params[:page]&.to_i || 1
      @rush_jobs = RushJob.locked_by_desc.paginate(@page)
    end
  end
end
