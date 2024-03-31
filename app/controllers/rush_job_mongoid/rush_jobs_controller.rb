module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @pagination_presenter = PaginationPresenter.new(params[:page])
      @rush_jobs = RushJob.filter(filter_params).locked_by_desc.paginate(@pagination_presenter.page, 20)
    end

    def edit
      @job = RushJob.find(params[:id])
    end

    def update
      @job = RushJob.find(params[:id])
      @job.update(update_params)

      redirect_to rush_jobs_path(doc_id: @job.id)
    end

    private

    def filter_params
      params.permit(:doc_id, :priority, :attempts, :job_class, :arguments, :locked_by, :last_error, :queue)
    end

    def update_params
      params.require(:rush_job).permit(:priority, :attempts, :handler, :run_at, :locked_by, :last_error, :queue)
    end
  end
end
