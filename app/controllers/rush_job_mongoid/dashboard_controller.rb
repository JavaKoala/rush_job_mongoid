module RushJobMongoid
  class DashboardController < ApplicationController
    def index
      @locked_jobs_page = params[:locked_jobs_page]&.to_i || 1
      @locked_jobs_pages_count = RushJob.pages_count(RushJob.locked_jobs.count)
      @locked_jobs = RushJob.locked_jobs.locked_by_desc.paginate(@locked_jobs_page)

      @queue_groups_page = params[:queue_groups_page]&.to_i || 1
      @rush_job_queue_groups = RushJob.queue_groups
      @queue_groups_pages_count = RushJob.pages_count(@rush_job_queue_groups.count, 10)
      @queue_groups = @rush_job_queue_groups[(@queue_groups_page - 1) * 10, 10]
    end
  end
end
