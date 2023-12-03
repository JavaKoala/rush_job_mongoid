require 'application_system_test_case'

module RushJobMongoid
  class RushJobsPaginationTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'No pagination for a single page' do
      visit '/rush_job_mongoid/rush_jobs'

      assert_no_selector '.pagination'
    end

    test 'Pagination for multiple pages' do
      50.times do
        RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                       run_at: Time.zone.now,
                       locked_at: Time.zone.now,
                       locked_by: '',
                       failed_at: Time.zone.now,
                       last_error: '',
                       queue: 'default')
      end

      visit '/rush_job_mongoid/rush_jobs'

      assert_selector '.pagination'
    end
  end
end
