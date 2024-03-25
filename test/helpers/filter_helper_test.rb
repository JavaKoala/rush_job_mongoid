require 'test_helper'

module RushJobMongoid
  class FilterHelperTest < ActionView::TestCase
    test 'filter_param_query returns filter parameters' do
      params[:doc_id] = 'test_doc_id'
      params[:priority] = 'test_priority'
      params[:attempts] = 'test_attempts'
      params[:job_class] = 'test_job_class'
      params[:arguments] = 'test_arguments'
      params[:locked_by] = 'test_locked_by'
      params[:last_error] = 'test_last_error'
      params[:queue] = 'test_queue'

      expected = {
        doc_id: 'test_doc_id',
        priority: 'test_priority',
        attempts: 'test_attempts',
        job_class: 'test_job_class',
        arguments: 'test_arguments',
        locked_by: 'test_locked_by',
        last_error: 'test_last_error',
        queue: 'test_queue'
      }

      assert_equal filter_param_query, expected
    end
  end
end
