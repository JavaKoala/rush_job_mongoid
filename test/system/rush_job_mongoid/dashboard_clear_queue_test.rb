require 'application_system_test_case'

module RushJobMongoid
  class DashboardClearQueueTest < ApplicationSystemTestCase
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

    test 'clear queue' do
      visit '/rush_job_mongoid'

      assert_text 'Queue 0'

      click_link 'Options'
      accept_confirm do
        click_button 'Enable Editing'
      end

      assert_difference 'RushJob.queue_groups.count', -1 do
        accept_confirm do
          click_button('Clear', match: :first)
        end

#        assert_text 'Cleared queue Queue 0'

        click_button 'Reload'
      end

      assert_no_text 'Queue 0'
      assert_text 'Queue 1'
    end
  end
end
