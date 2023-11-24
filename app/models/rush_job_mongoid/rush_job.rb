module RushJobMongoid
  class RushJob
    include Mongoid::Document

    store_in collection: 'delayed_backend_mongoid_jobs'

    field :priority,   type: Integer, default: 0
    field :attempts,   type: Integer, default: 0
    field :handler,    type: String
    field :run_at,     type: Time
    field :locked_at,  type: Time
    field :locked_by,  type: String
    field :failed_at,  type: Time
    field :last_error, type: String
    field :queue,      type: String

    scope :locked_by_desc, -> { order_by(locked_by: -1, priority: 1, run_at: 1) }

    def job_class
      job_data[:job_class]
    end

    def job_arguments
      job_data[:arguments].presence || ''
    end

    private

    def handler_hash
      safe_yaml = handler.sub('!ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper', '')
      Psych.safe_load(safe_yaml, symbolize_names: true)
    end

    def job_data
      handler_hash[:job_data]
    end
  end
end
