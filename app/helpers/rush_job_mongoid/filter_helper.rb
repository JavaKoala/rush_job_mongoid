module RushJobMongoid
  module FilterHelper
    def filter_param_query
      {
        doc_id: params[:doc_id],
        priority: params[:priority],
        attempts: params[:attempts],
        job_class: params[:job_class],
        arguments: params[:arguments],
        locked_by: params[:locked_by],
        last_error: params[:last_error],
        queue: params[:queue]
      }
    end
  end
end
