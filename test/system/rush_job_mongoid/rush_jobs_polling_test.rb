require 'application_system_test_case'

module RushJobMongoid
  class RushJobsPollingTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start

      2.times do |n|
        RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                       run_at: Time.zone.now,
                       locked_at: Time.zone.now,
                       locked_by: "Server #{n}",
                       failed_at: Time.zone.now,
                       last_error: '',
                       queue: "Queue #{n}")
      end
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'rush jobs polling' do
      visit '/rush_job_mongoid/rush_jobs'

      assert_text 'Polling time: 13 seconds'

      find(:xpath, "//input[@id='rush-job-mongoid-polling-range']").set 0

      assert_text 'Polling time: 3 seconds'
      assert_text 'Server 0'
      assert_text 'Server 1'
      assert_no_selector '#rush-job-mongoid-polling-progress'

      find(:xpath, "//input[@id='rush-job-mongoid-polling']").set true

      assert_selector '#rush-job-mongoid-polling-progress'

      RushJob.find_by(locked_by: 'Server 0').delete
      sleep 4

      assert_no_text 'Server 0'
      assert_text 'Server 1'
    end
  end
end
