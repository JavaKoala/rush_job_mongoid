require 'application_system_test_case'

module RushJobMongoid
  class RushJobsPaginationTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    def create_jobs(number_of_jobs = 50)
      number_of_jobs.times do |n|
        RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                                "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                       run_at: Time.zone.now,
                       locked_at: Time.zone.now,
                       locked_by: '',
                       failed_at: Time.zone.now,
                       last_error: '',
                       queue: "Queue #{n}")
      end
    end

    test 'No pagination for a single page' do
      visit '/rush_job_mongoid/rush_jobs'

      assert_no_selector '.pagination'
    end

    test 'Pagination for multiple pages' do
      create_jobs
      visit '/rush_job_mongoid/rush_jobs'

      assert_selector '.pagination'
      assert_text 'Queue 0'
      assert_text 'Queue 19'
      assert_no_text 'Queue 20'
      assert_no_text '...'
      assert_link 'Previous'
      assert_css '.disabled', text: 'Previous'
      assert_link '1'
      assert_css '.active', text: '1'
      assert_link '2'
      assert_no_css '.active', text: '2'
    end

    test 'Next button' do
      create_jobs
      visit '/rush_job_mongoid/rush_jobs'

      click_link 'Next'
      assert_text 'Queue 20'
      assert_text 'Queue 39'
      assert_no_text 'Queue 40'
      assert_no_css '.disabled', text: 'Previous'
      assert_link '1'
      assert_no_css '.active', text: '1'
      assert_link '2'
      assert_css '.active', text: '2'
    end

    test 'Previous button' do
      create_jobs
      visit '/rush_job_mongoid/rush_jobs'

      click_link 'Next'
      click_link 'Previous'
      assert_text 'Queue 0'
      assert_text 'Queue 19'
      assert_css '.disabled', text: 'Previous'
    end

    test 'Last link' do
      create_jobs
      visit '/rush_job_mongoid/rush_jobs'

      click_link '3'
      assert_text 'Queue 40'
      assert_text 'Queue 49'
      assert_no_css '.disabled', text: 'Previous'
      assert_css '.active', text: '3'
      assert_css '.disabled', text: 'Next'
    end

    test 'Many pages' do
      create_jobs(200)
      visit '/rush_job_mongoid/rush_jobs'

      assert_text '...'

      click_link '9'

      assert_link '1'
      assert_link '2'

      click_link 'Previous'

      assert_link '7'
      assert_link '10'
    end
  end
end
