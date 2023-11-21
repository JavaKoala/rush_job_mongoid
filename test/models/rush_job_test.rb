require 'test_helper'

module RushJobMongoid
  class RushJobTest < ActiveSupport::TestCase
    setup do
      @example_handler = "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\njob_data:\n  " \
                         "job_class: TestHandler\n  arguments:\n  - arg1"
    end

    test 'job_class returns class of the job' do
      rush_job = RushJob.new
      rush_job.handler = @example_handler

      assert_equal rush_job.job_class, 'TestHandler'
    end

    test 'job_arguments returns arguments of the job' do
      rush_job = RushJob.new
      rush_job.handler = @example_handler

      assert_equal rush_job.job_arguments, ['arg1']
    end
  end
end
