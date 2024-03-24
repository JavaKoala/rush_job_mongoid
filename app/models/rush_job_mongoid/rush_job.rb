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

    scope :locked_jobs, -> { where(:locked_at.exists => true) }
    scope :locked_by_desc, -> { order_by(locked_by: -1, priority: 1, run_at: 1) }
    scope :paginate, ->(page, jobs_per_page) { limit(jobs_per_page).skip(jobs_per_page * (page - 1)) }
    scope :by_doc_id, ->(doc_id) { where(_id: doc_id) if doc_id.present? }
    scope :by_priority, ->(queue_priority) { where(priority: queue_priority) if queue_priority.present? }
    scope :by_attempts, ->(attempt_number) { where(attempts: attempt_number) if attempt_number.present? }
    scope :by_job_class, ->(job_class) { where(handler: /#{job_class}/i) if job_class.present? }
    scope :by_arguments, ->(job_arguments) { where(handler: /#{job_arguments}/i) if job_arguments.present? }
    scope :by_locked_by, ->(job_locked_by) { where(locked_by: job_locked_by) if job_locked_by.present? }
    scope :by_last_error, ->(last_error) { where(last_error: /#{last_error}/i) if last_error.present? }
    scope :by_queue, ->(job_queue) { where(queue: job_queue) if job_queue.present? }

    def job_class
      job_data[:job_class]
    end

    def job_arguments
      job_data[:arguments].presence || ''
    end

    def self.queue_groups
      groups = collection.aggregate([
                                      { '$group' => {
                                        _id: { 'queue' => '$queue', 'priority' => '$priority' }, count: { '$sum' => 1 }
                                      } }
                                    ]).to_a

      group_result = []

      groups.each do |group|
        group_result << { queue: group['_id']['queue'], priority: group['_id']['priority'], count: group['count'] }
      end

      group_result.sort_by! { |group| [group[:priority], group[:queue]] }
    end

    def self.clear_queue(queue_name, queue_priority)
      where(queue: queue_name, priority: queue_priority).delete_all
    end

    def self.filter(filter_params)
      by_doc_id(filter_params[:doc_id])
        .by_priority(filter_params[:priority])
        .by_attempts(filter_params[:attempts])
        .by_job_class(filter_params[:job_class])
        .by_arguments(filter_params[:arguments])
        .by_locked_by(filter_params[:locked_by])
        .by_last_error(filter_params[:last_error])
        .by_queue(filter_params[:queue])
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
