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

      priority = 50
      attempts = 5
      handler = @job1.handler.sub('TestHandler1', 'UpdatedHandler').sub('arg1', 'updatedArg')

      fill_in 'Priority', with: priority
      fill_in 'Attempts', with: attempts
      fill_in 'Handler', with: handler
      fill_in 'Run at', with: "03102024\t021507p"
      click_button 'Update'

      job_row = ['',
                 priority,
                 attempts,
                 'UpdatedHandler',
                 'updatedArg',
                 '2024-03-10 14:15:07 UTC',
                 @job1.locked_at.to_s,
                 @job1.locked_by.to_s,
                 @job1.failed_at.to_s,
                 @job1.last_error.to_s,
                 @job1.queue.to_s]

      assert_equal has_table?(rows: [job_row]), true
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
