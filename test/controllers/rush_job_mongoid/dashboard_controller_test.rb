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
  end
end
