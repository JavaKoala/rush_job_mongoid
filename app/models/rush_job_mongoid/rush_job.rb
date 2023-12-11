module RushJobMongoid
  class RushJob
    include Mongoid::Document

    JOBS_PER_PAGE = 20

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
    scope :paginate, ->(page) { limit(JOBS_PER_PAGE).skip(JOBS_PER_PAGE * (page - 1)) }

    def job_class
      job_data[:job_class]
    end

    def job_arguments
      job_data[:arguments].presence || ''
    end

    def self.pages_count(item_count, items_per_page = JOBS_PER_PAGE)
      (item_count / items_per_page.to_f).ceil
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
