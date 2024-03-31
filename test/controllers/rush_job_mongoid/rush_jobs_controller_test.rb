require 'test_helper'

module RushJobMongoid
  class RushJobsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      DatabaseCleaner.start
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'should get index' do
      get '/rush_job_mongoid/rush_jobs'

      assert_response :success
    end

    test 'should get edit page' do
      job = RushJob.create
      get "/rush_job_mongoid/rush_jobs/#{job.id}/edit"

      assert_response :success
      assert_select '.text-body', "Edit Job #{job.id}"
    end
  end
end
