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

    test 'by_doc_id returns documents by id' do
      job1 = RushJob.create
      RushJob.create

      assert_equal RushJob.by_doc_id(job1.id), [job1]
    end

    test 'by_doc_id returns all docs when the doc_id is not present' do
      job1 = RushJob.create
      job2 = RushJob.create

      assert_equal RushJob.by_doc_id(nil), [job1, job2]
    end

    test 'by_priority returns documents by priority' do
      job = RushJob.create(priority: 1)
      RushJob.create(priority: 2)

      assert_equal RushJob.by_priority(1), [job]
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
        RushJob.create(handler: @example_handler, priority: 0, queue: 'default')
      end

      3.times do
        RushJob.create(handler: @example_handler, priority: 1, queue: 'queue1')
      end

      RushJob.create(handler: @example_handler, priority: 0, queue: 'queue1')

      expected_groups = [{ queue: 'default', priority: 0, count: 2 }, { queue: 'queue1', priority: 0, count: 1 },
                         { queue: 'queue1', priority: 1, count: 3 }]
      assert_equal RushJob.queue_groups, expected_groups
    end

    test 'clear queue deletes jobs by priority' do
      2.times do |n|
        RushJob.create(handler: @example_handler, priority: n, queue: 'default')
      end

      RushJob.clear_queue('default', 0)

      assert_equal RushJob.queue_groups, [{ queue: 'default', priority: 1, count: 1 }]
    end

    test 'clear queue deletes jobs by queue name' do
      2.times do |n|
        RushJob.create(handler: @example_handler, priority: 0, queue: "default#{n}")
      end

      RushJob.clear_queue('default0', 0)

      assert_equal RushJob.queue_groups, [{ queue: 'default1', priority: 0, count: 1 }]
    end

    test 'filter filters by document id' do
      job1 = RushJob.create
      RushJob.create

      assert_equal RushJob.filter({ doc_id: job1.id }), [job1]
    end

    test 'filter filters by priority' do
      job1 = RushJob.create(priority: 1)
      RushJob.create(priority: 2)

      assert_equal RushJob.filter({ priority: 1 }), [job1]
    end
  end
end
