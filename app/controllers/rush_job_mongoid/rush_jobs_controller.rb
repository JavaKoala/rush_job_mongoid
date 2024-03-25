module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @pagination_presenter = PaginationPresenter.new(params[:page])
      @rush_jobs = RushJob.filter(filter_params).locked_by_desc.paginate(@pagination_presenter.page, 20)
    end

    private

    def filter_params
      params.permit(:doc_id, :priority, :attempts, :job_class, :arguments, :locked_by, :last_error, :queue)
    end
  end
end
