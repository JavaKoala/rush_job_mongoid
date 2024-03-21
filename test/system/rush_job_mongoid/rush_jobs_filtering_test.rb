require 'application_system_test_case'

module RushJobMongoid
  class RushJobsFilteringTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start

      @job1 = RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                      "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                             run_at: Time.zone.now,
                             locked_at: Time.zone.now,
                             locked_by: 'Server 1',
                             failed_at: Time.zone.now,
                             last_error: '',
                             queue: 'Queue 1')

      @job2 = RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                      "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                             run_at: Time.zone.now,
                             locked_at: Time.zone.now,
                             locked_by: 'Server 2',
                             failed_at: Time.zone.now,
                             last_error: '',
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

      fill_in 'id', with: @job1.id.to_s
      click_button 'Filter'

      find_link('Jobs', class: 'nav-link active')
      assert_no_text 'Queue 2'

      click_link 'Filter'

      assert_field 'id:', with: @job1.id.to_s
    end

    test 'maintain filters between pages' do
      visit '/rush_job_mongoid/rush_jobs'
      click_link 'Filter'
      fill_in 'id', with: @job1.id.to_s
      click_button 'Filter'
      click_link 'Jobs'

      assert_no_text @job2.id.to_s
    end
  end
end
