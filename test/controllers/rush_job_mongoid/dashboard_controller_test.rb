require 'test_helper'

module RushJobMongoid
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'should get index' do
      get '/rush_job_mongoid'

      assert_response :success
    end

    test 'should display locked jobs' do
      locked_at = Time.zone.now
      job_handler = "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\njob_data:\n  " \
                    "job_class: TestHandler\n  arguments:\n  - arg1"
      job = RushJob.create(locked_by: 'JobRunner', locked_at:, handler: job_handler)

      get '/rush_job_mongoid'

      assert_select '#rush-job-mongoid-dashboard-locked-jobs' do
        assert_select 'th:nth-child(1)', 'Id'
        assert_select 'th:nth-child(2)', 'Locked at'
        assert_select 'th:nth-child(3)', 'Locked by'
        assert_select 'th:nth-child(4)', 'Job class'
        assert_select 'th:nth-child(5)', 'Arguments'

        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', job.id.to_s
          assert_select 'td:nth-child(2)', locked_at.to_s
          assert_select 'td:nth-child(3)', 'JobRunner'
          assert_select 'td:nth-child(4)', 'TestHandler'
          assert_select 'td:nth-child(5)', '["arg1"]'
        end
      end
    end

    test 'should display queues' do
      3.times do
        RushJob.create(queue: 'JobQueue0', priority: 2)
      end

      get '/rush_job_mongoid'

      assert_select '#rush-job-mongoid-dashboard-queues' do
        assert_select 'th:nth-child(1)', 'Name'
        assert_select 'th:nth-child(2)', 'Priority'
        assert_select 'th:nth-child(3)', 'Count'

        assert_select 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', 'JobQueue0'
          assert_select 'td:nth-child(2)', '2'
          assert_select 'td:nth-child(3)', '3'
        end
      end
    end

    test 'should clear queue' do
      RushJob.create(queue: 'JobQueue0', priority: 2)

      assert_difference 'RushJob.queue_groups.count', -1 do
        delete '/rush_job_mongoid/dashboard', params: { queue: 'JobQueue0', priority: 2 }

        assert_redirected_to root_path
        assert_equal 'Cleared queue JobQueue0', flash[:success]
      end
    end
  end
end
