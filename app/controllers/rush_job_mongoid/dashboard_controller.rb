module RushJobMongoid
  class DashboardController < ApplicationController
    def index
      @locked_jobs_presenter = PaginationPresenter.new(params[:locked_jobs_page])
      @locked_jobs = RushJob.locked_jobs.locked_by_desc.paginate(@locked_jobs_presenter.page, 10)

      @queue_groups_presenter = PaginationPresenter.new(params[:queue_groups_page])
      @rush_job_queue_groups = RushJob.queue_groups
      @queue_groups = @rush_job_queue_groups[(@queue_groups_presenter.page - 1) * 10, 10]
    end
  end
end
