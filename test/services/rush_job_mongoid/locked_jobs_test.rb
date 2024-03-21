require 'test_helper'

module RushJobMongoid
  class LockedJobsTest < ActiveSupport::TestCase
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'jobs returns locked jobs' do
      locked_job = RushJob.create(locked_at: Time.zone.now)
      RushJob.create
      locked_jobs = LockedJobs.new

      assert_equal locked_jobs.jobs.count, 1
      assert_equal locked_jobs.jobs.first, locked_job
    end

    test 'jobs returns filtered jobs' do
      locked_job = RushJob.create(locked_at: Time.zone.now)
      RushJob.create(locked_at: Time.zone.now)
      locked_jobs = LockedJobs.new(doc_id: locked_job.id)

      assert_equal locked_jobs.jobs.count, 1
      assert_equal locked_jobs.jobs.first.id.to_s, locked_job.id.to_s
    end

    test 'pagination query' do
      locked_jobs = LockedJobs.new

      assert_equal locked_jobs.paginate(1).selector, { 'locked_at' => { '$exists' => true } }
      assert_equal locked_jobs.paginate(1).options,
                   { sort: { 'locked_by' => -1, 'priority' => 1, 'run_at' => 1 }, limit: 10, skip: 0 }
    end

    test 'pagination query with filter' do
      locked_jobs = LockedJobs.new(doc_id: 'test-id')

      assert_equal locked_jobs.paginate(1).selector, { '_id' => 'test-id', 'locked_at' => { '$exists' => true } }
      assert_equal locked_jobs.paginate(1).options,
                   { sort: { 'locked_by' => -1, 'priority' => 1, 'run_at' => 1 }, limit: 10, skip: 0 }
    end

    test 'pagination query with number of jobs' do
      locked_jobs = LockedJobs.new

      assert_equal locked_jobs.paginate(3, 20).options,
                   { sort: { 'locked_by' => -1, 'priority' => 1, 'run_at' => 1 }, limit: 20, skip: 40 }
    end
  end
end
