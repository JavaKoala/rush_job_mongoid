module RushJobMongoid
  class DashboardController < ApplicationController
    def index
      @locked_jobs = RushJob.locked_jobs.locked_by_desc

      @queue_groups_page = params[:queue_groups_page]&.to_i || 1
      @rush_job_queue_groups = RushJob.queue_groups
      @queue_groups_pages_count = RushJob.pages_count(@rush_job_queue_groups.count, 10)
      @queue_groups = @rush_job_queue_groups[(@queue_groups_page - 1) * 10, 10]
    end
  end
end
