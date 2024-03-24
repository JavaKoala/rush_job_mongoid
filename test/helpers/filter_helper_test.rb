require 'test_helper'

module RushJobMongoid
  class FilterHelperTest < ActionView::TestCase
    test 'filter_param_query returns filter parameters' do
      params[:doc_id] = 'test_doc_id'
      params[:priority] = 'test_priority'
      params[:attempts] = 'test_attempts'
      params[:job_class] = 'test_job_class'
      params[:arguments] = 'test_arguments'

      expected = {
        doc_id: 'test_doc_id',
        priority: 'test_priority',
        attempts: 'test_attempts',
        job_class: 'test_job_class',
        arguments: 'test_arguments'
      }

      assert_equal filter_param_query, expected
    end
  end
end
