require 'application_system_test_case'

module RushJobMongoid
  class RushJobsFilteringTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start

      @job1 = RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                      "job_data:\n  job_class: TestHandler1\n  arguments:\n  - arg1",
                             run_at: Time.zone.now,
                             locked_at: Time.zone.now,
                             locked_by: 'Server 1',
                             failed_at: Time.zone.now,
                             last_error: 'Error1',
                             priority: 0,
                             attempts: 1,
                             queue: 'Queue 1')

      visit '/rush_job_mongoid/'
      click_link 'Options'
      accept_confirm do
        click_button 'Enable Editing'
      end
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'edit job' do
      visit '/rush_job_mongoid/rush_jobs'
      find("#rush-job-mongoid-pencil-square-#{@job1.id}").click

      assert_text "Edit Job #{@job1.id}"
    end

    test 'edit not displayed when editing is not enabled' do
      click_link 'Options'
      accept_confirm do
        click_button 'Disable Editing'
      end
      visit '/rush_job_mongoid/rush_jobs'

      assert_no_selector("#rush-job-mongoid-pencil-square-#{@job1.id}")
    end
  end
end
