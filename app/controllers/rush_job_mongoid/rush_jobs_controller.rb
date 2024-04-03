module RushJobMongoid
  class RushJobsController < ApplicationController
    before_action :find_job, only: %i[edit update]

    def index
      @pagination_presenter = PaginationPresenter.new(params[:page])
      @rush_jobs = RushJob.filter(filter_params).locked_by_desc.paginate(@pagination_presenter.page, 20)
    end

    def edit
      flash.now[:warning] = t(:edit_warning)
    end

    def update
      if @job.update(update_params)
        flash[:success] = t(:updated_job, job_id: @job.id)
        redirect_to rush_jobs_path(doc_id: @job.id)
      else
        flash[:danger] = t(:unable_to_update, errors: @job.errors.full_messages.to_sentence)
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def find_job
      @job = RushJob.find(params[:id])
    end

    def filter_params
      params.permit(:doc_id, :priority, :attempts, :job_class, :arguments, :locked_by, :last_error, :queue)
    end

    def update_params
      params.require(:rush_job).permit(:priority,
                                       :attempts,
                                       :handler,
                                       :run_at,
                                       :locked_at,
                                       :locked_by,
                                       :failed_at,
                                       :last_error,
                                       :queue)
    end
  end
end
