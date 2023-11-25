module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @page = params[:page]&.to_i || 1
      @pages_count = RushJobMongoid::RushJob.pages_count
      @rush_jobs = RushJob.locked_by_desc.paginate(@page)
    end
  end
end
