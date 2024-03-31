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

    test 'jobs without a priority are not valid' do
      job = RushJob.create(priority: nil)

      assert_equal job.valid?, false
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

    test 'by_priority returns all docs when the priority is not present' do
      RushJob.create(priority: 1)
      RushJob.create(priority: 2)

      assert_equal RushJob.by_priority(nil).count, 2
    end

    test 'by_attempts returns documents by attempt' do
      job = RushJob.create(attempts: 1)
      RushJob.create(attempts: 2)

      assert_equal RushJob.by_attempts(1), [job]
    end

    test 'by_attempts returns all docs when the attempts is not present' do
      RushJob.create(attempts: 1)
      RushJob.create(attempts: 2)

      assert_equal RushJob.by_attempts(nil).count, 2
    end

    test 'by_job_class returns documents by attempt' do
      job = RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.by_job_class('Test'), [job]
    end

    test 'by_job_class returns all docs when the attempts are not present' do
      RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.by_job_class(nil).count, 2
    end

    test 'by_arguments returns documents by arguemnt' do
      job = RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.by_arguments('Test'), [job]
    end

    test 'by_arguments returns all docs when the arguments are not present' do
      RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.by_arguments(nil).count, 2
    end

    test 'by_locked_by returns documents by locked_by' do
      job = RushJob.create(locked_by: 'testServer')
      RushJob.create(locked_by: 'fooServer')

      assert_equal RushJob.by_locked_by('testServer'), [job]
    end

    test 'by_locked_by returns all docs when the locked by is not present' do
      RushJob.create(locked_by: 'testServer')
      RushJob.create(locked_by: 'fooServer')

      assert_equal RushJob.by_locked_by(nil).count, 2
    end

    test 'by_last_error returns documents by last_error' do
      job = RushJob.create(last_error: 'foo test bar')
      RushJob.create(last_error: 'foobar')

      assert_equal RushJob.by_last_error('Test'), [job]
    end

    test 'by_last_error returns all docs when the arguments are not present' do
      RushJob.create(last_error: 'foo test bar')
      RushJob.create(last_error: 'foobar')

      assert_equal RushJob.by_last_error(nil).count, 2
    end

    test 'by_queue returns jobs by queue' do
      job = RushJob.create(queue: 'test_queue')
      RushJob.create(queue: 'foo_queue')

      assert_equal RushJob.by_queue('test_queue'), [job]
    end

    test 'by_queue returns all docs when the queue is not present' do
      RushJob.create(queue: 'test_queue')
      RushJob.create(queue: 'foo_queue')

      assert_equal RushJob.by_queue(nil).count, 2
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

    test 'filter filters by attempts' do
      job1 = RushJob.create(attempts: 1)
      RushJob.create(attempts: 2)

      assert_equal RushJob.filter({ attempts: 1 }), [job1]
    end

    test 'filter filters by job class' do
      job1 = RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.filter({ job_class: 'Test' }), [job1]
    end

    test 'filter filters by argumments' do
      job1 = RushJob.create(handler: 'foo test bar')
      RushJob.create(handler: 'foobar')

      assert_equal RushJob.filter({ arguments: 'Test' }), [job1]
    end

    test 'filter filters by locked_by' do
      job1 = RushJob.create(locked_by: 'testServer')
      RushJob.create(locked_by: 'fooServer')

      assert_equal RushJob.filter({ locked_by: 'testServer' }), [job1]
    end

    test 'filter filters by last_error' do
      job1 = RushJob.create(last_error: 'foo test error')
      RushJob.create(last_error: 'fooError')

      assert_equal RushJob.filter({ last_error: 'test' }), [job1]
    end

    test 'filter filters by queue' do
      job1 = RushJob.create(queue: 'test_queue')
      RushJob.create(queue: 'foo_queue')

      assert_equal RushJob.filter({ queue: 'test_queue' }), [job1]
    end
  end
end
