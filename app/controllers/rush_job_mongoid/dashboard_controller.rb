module RushJobMongoid
  class DashboardController < ApplicationController
    def index
      @locked_jobs_presenter = PaginationPresenter.new(params[:locked_jobs_page])
      @locked_jobs = LockedJobs.new(filter_params)

      @queue_groups_presenter = PaginationPresenter.new(params[:queue_groups_page])
      @rush_job_queue_groups = RushJob.queue_groups
      @queue_groups = @rush_job_queue_groups[(@queue_groups_presenter.page - 1) * 10, 10]
    end

    def destroy
      RushJob.clear_queue(queue_params[:queue], queue_params[:priority])

      flash[:success] = t(:cleared_queue, queue: params[:queue])
      redirect_to root_path, status: :see_other
    end

    private

    def queue_params
      params.permit(:queue, :priority)
    end

    def filter_params
      params.permit(:doc_id, :priority, :attempts, :job_class, :arguments, :locked_by, :last_error, :queue)
    end
  end
end
