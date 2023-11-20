module RushJobMongoid
  class RushJob
    include Mongoid::Document

    store_in collection: 'delayed_backend_mongoid_jobs'

    field :priority,    type: Integer, default: 0
    field :attempts,    type: Integer, default: 0
    field :handler,     type: String
    field :run_at,      type: Time
    field :locked_at,   type: Time
    field :locked_by,   type: String
    field :failed_at,   type: Time
    field :last_error,  type: String
    field :queue,       type: String

    index locked_by: -1, priority: 1, run_at: 1
    index queue: 1, locked_by: -1, priority: 1, run_at: 1
    index failed_at: 1, locked_by: -1, priority: 1, run_at: 1
    index failed_at: 1, queue: 1, locked_by: -1, priority: 1, run_at: 1
  end
end
