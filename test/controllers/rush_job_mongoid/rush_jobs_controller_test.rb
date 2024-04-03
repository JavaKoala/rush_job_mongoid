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
      assert_equal 'Verify workers are stopped before editing. Minimal validations are applied.', flash[:warning]
    end

    test 'successful edit should redirect to index' do
      job = RushJob.create
      patch rush_job_url(job), params: { rush_job: { priority: 10 } }

      assert_redirected_to rush_jobs_path(doc_id: job.id)
      assert_equal "Successfully updated job #{job.id}", flash[:success]
      assert_equal job.reload.priority, 10
    end

    test 'unsuccessful edit' do
      job = RushJob.create
      patch rush_job_url(job), params: { rush_job: { priority: '' } }

      assert_response :unprocessable_entity
      assert_equal "Unable to edit job. Priority can't be blank", flash[:danger]
    end
  end
end
