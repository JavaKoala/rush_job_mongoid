module RushJobMongoid
  class RushJobsController < ApplicationController
    def index
      @pagination_presenter = PaginationPresenter.new(params[:page])
      @rush_jobs = RushJob.locked_by_desc.paginate(@pagination_presenter.page, 20)
    end
  end
end
