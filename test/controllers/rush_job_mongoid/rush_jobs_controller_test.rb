require 'test_helper'

module RushJobMongoid
  class RushJobsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get '/rush_job_mongoid/rush_jobs'

      assert_response :success
    end
  end
end
