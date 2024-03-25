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

      @job2 = RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                      "job_data:\n  job_class: TestHandler2\n  arguments:\n  - arg2",
                             run_at: Time.zone.now,
                             locked_at: Time.zone.now,
                             locked_by: 'Server 2',
                             failed_at: Time.zone.now,
                             last_error: 'Error2',
                             priority: 1,
                             attempts: 2,
                             queue: 'Queue 2')
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'filter by id' do
      visit '/rush_job_mongoid/rush_jobs'

      assert_text 'Queue 1'

      click_link 'Filter'

      assert_text 'Filter jobs'

      fill_in 'Id', with: @job1.id.to_s
      click_button 'Filter'

      find_link('Jobs', class: 'nav-link active')
      assert_no_text 'Queue 2'

      click_link 'Filter'

      assert_field 'Id', with: @job1.id.to_s
    end

    test 'filter by priority' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Priority', with: @job2.priority
      click_button 'Filter'

      assert_text @job2.queue
      assert_no_text @job1.queue
    end

    test 'filter by attempts' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Attempts', with: @job1.attempts
      click_button 'Filter'

      assert_text @job1.queue
      assert_no_text @job2.queue
    end

    test 'filter by job class' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Job class', with: 'TestHandler1'
      click_button 'Filter'

      assert_text 'TestHandler1'
      assert_no_text 'TestHandler2'
    end

    test 'filter by arguments' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Arguments', with: 'arg1'
      click_button 'Filter'

      assert_text 'arg1'
      assert_no_text 'arg2'
    end

    test 'filter by locked by' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Locked by', with: @job1.locked_by
      click_button 'Filter'

      assert_text @job1.locked_by
      assert_no_text @job2.locked_by
    end

    test 'filter by last error' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Last error', with: @job1.last_error
      click_button 'Filter'

      assert_text @job1.last_error
      assert_no_text @job2.last_error
    end

    test 'filter by queue' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Queue', with: @job1.queue
      click_button 'Filter'

      assert_text @job1.queue
      assert_no_text @job2.queue
    end

    test 'maintain filters between pages' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'Id', with: @job1.id.to_s
      click_button 'Filter'
      click_link 'Jobs'

      assert_no_text @job2.id.to_s
    end
  end
end
