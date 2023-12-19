require 'application_system_test_case'

module RushJobMongoid
  class DashboardPaginationTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    def create_jobs(number_of_jobs = 25)
      handler = "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\njob_data:\n  " \
                "job_class: TestHandler\n  arguments:\n  - arg1"

      number_of_jobs.times do |n|
        RushJob.create(queue: "Queue #{n}",
                       priority: n,
                       handler:,
                       locked_at: Time.zone.now + n.minutes,
                       locked_by: "Locked #{n}")
      end
    end

    test 'No pagination for a single page' do
      visit '/rush_job_mongoid'

      assert_no_selector '.pagination'
    end

    test 'Locked jobs pagination for multiple pages' do
      create_jobs
      visit '/rush_job_mongoid'

      within 'div#rush-job-mongoid-dashboard-locked-jobs' do
        assert_selector '.pagination'
        assert_text 'Locked 9'
        assert_text 'Locked 22'
        assert_no_text 'Locked 0'

        click_link 'Next'

        assert_text 'Locked 13'
      end
    end

    test 'Queue group pagination for multiple pages' do
      create_jobs
      visit '/rush_job_mongoid'

      within 'div#rush-job-mongoid-dashboard-queues' do
        assert_selector '.pagination'
        assert_text 'Queue 0'
        assert_text 'Queue 9'
        assert_no_text 'Queue 10'
        assert_no_text '...'
        assert_link 'Previous'
        assert_css '.disabled', text: 'Previous'
        assert_link '1'
        assert_css '.active', text: '1'
        assert_link '2'
        assert_no_css '.active', text: '2'
      end
    end

    test 'Next queue group button' do
      create_jobs
      visit '/rush_job_mongoid'

      within 'div#rush-job-mongoid-dashboard-queues' do
        click_link 'Next'
        assert_text 'Queue 10'
        assert_text 'Queue 19'
        assert_no_text 'Queue 20'
        assert_no_css '.disabled', text: 'Previous'
        assert_link '1'
        assert_no_css '.active', text: '1'
        assert_link '2'
        assert_css '.active', text: '2'
      end
    end

    test 'Last queue group link' do
      create_jobs
      visit '/rush_job_mongoid'

      within 'div#rush-job-mongoid-dashboard-queues' do
        click_link '3'
        assert_text 'Queue 20'
        assert_text 'Queue 24'
        assert_no_css '.disabled', text: 'Previous'
        assert_css '.active', text: '3'
        assert_css '.disabled', text: 'Next'
      end
    end

    test 'Pagination links work together' do
      create_jobs
      visit '/rush_job_mongoid'

      within 'div#rush-job-mongoid-dashboard-queues' do
        click_link 'Next'
        assert_text 'Queue 10'
      end

      within 'div#rush-job-mongoid-dashboard-locked-jobs' do
        click_link 'Next'
        assert_no_text 'Locked 9'
      end

      assert_text 'Queue 10'
    end
  end
end
