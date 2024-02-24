require 'application_system_test_case'

module RushJobMongoid
  class DashboardReloadTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start

      3.times do |n|
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

    test 'reload button' do
      visit '/rush_job_mongoid'

      assert_text 'TestHandler', count: 3
      assert_text 'Server', count: 3

      RushJob.find_by(locked_by: 'Server 2').delete

      click_button 'Reload'

      assert_no_text 'Server 2'
      assert_text 'Server 1', count: 1
    end
  end
end
