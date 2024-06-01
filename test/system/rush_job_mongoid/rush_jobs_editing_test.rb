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

    test 'back button' do
      visit '/rush_job_mongoid/rush_jobs'
      find("#rush-job-mongoid-pencil-square-#{@job1.id}").click
      fill_in 'Queue', with: 'Updated Queue'
      click_link 'Back'

      assert_text 'Queue 1'
      assert_no_text 'Updated Queue'
    end

    test 'edit job' do
      visit '/rush_job_mongoid/rush_jobs'
      find("#rush-job-mongoid-pencil-square-#{@job1.id}").click

      assert_text "Edit Job #{@job1.id}"
      assert_text 'Verify workers are stopped before editing. Minimal validations are applied.'

      priority = 50
      attempts = 5
      handler = @job1.handler.sub('TestHandler1', 'UpdatedHandler').sub('arg1', 'updatedArg')
      locked_by = 'Updated Server1'
      last_error = 'Updated Last Error'
      queue = 'Updated Queue 1'

      fill_in 'Priority', with: priority
      fill_in 'Attempts', with: attempts
      fill_in 'Handler', with: handler
      fill_in 'Run at', with: "03102024\t021507p"
      fill_in 'Locked at', with: "01202024\t054512a"
      fill_in 'Locked by', with: locked_by
      fill_in 'Failed at', with: "12252023\t120401p"
      fill_in 'Last error', with: last_error
      fill_in 'Queue', with: queue
      click_button 'Update'

      job_row = ['', priority, attempts,
                 'UpdatedHandler', 'updatedArg', '2024-03-10 14:15:07 UTC',
                 '2024-01-20 05:45:12 UTC', locked_by, '2023-12-25 12:04:01 UTC',
                 last_error, queue]

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

    test 'invalid edit' do
      visit '/rush_job_mongoid/rush_jobs'
      find("#rush-job-mongoid-pencil-square-#{@job1.id}").click
      fill_in 'Priority', with: ''

      click_button 'Update'

      assert_text "Edit Job #{@job1.id}"
      assert_text "Unable to edit job. Priority can't be blank"
    end

    test 'delete job' do
      visit '/rush_job_mongoid/rush_jobs'
      find("#rush-job-mongoid-pencil-square-#{@job1.id}").click
      accept_confirm do
        click_button 'Delete'
      end

      assert_text "Deleted job #{@job1.id}"

      click_link 'Filter'
      fill_in 'Id', with: @job1.id.to_s
      click_button 'Filter'

      assert_no_text @job1.queue
    end
  end
end
