require 'test_helper'

module RushJobMongoid
  class RushJobTest < ActiveSupport::TestCase
    setup do
      DatabaseCleaner.start

      @example_handler = "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\njob_data:\n  " \
                         "job_class: TestHandler\n  arguments:\n  - arg1"
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'locked_jobs returns locked jobs' do
      locked_job = RushJob.create(locked_at: Time.zone.now)
      RushJob.create

      assert_equal RushJob.locked_jobs.count, 1
      assert_equal RushJob.locked_jobs.first, locked_job
    end

    test 'job_class returns class of the job' do
      rush_job = RushJob.new
      rush_job.handler = @example_handler

      assert_equal rush_job.job_class, 'TestHandler'
    end

    test 'job_arguments returns arguments of the job' do
      rush_job = RushJob.new
      rush_job.handler = @example_handler

      assert_equal rush_job.job_arguments, ['arg1']
    end

    test 'queue_groups counts queue and priority' do
      2.times do
        RushJob.create(handler: @example_handler, priority: 0, queue: 'defualt')
      end

      3.times do
        RushJob.create(handler: @example_handler, priority: 1, queue: 'queue1')
      end

      RushJob.create(handler: @example_handler, priority: 0, queue: 'queue1')

      expected_groups = [{ queue: 'defualt', priority: 0, count: 2 }, { queue: 'queue1', priority: 0, count: 1 },
                         { queue: 'queue1', priority: 1, count: 3 }]
      assert_equal RushJob.queue_groups, expected_groups
    end
  end
end
