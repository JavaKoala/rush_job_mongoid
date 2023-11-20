require 'test_helper'

module RushJobMongoid
  class RushJobTest < ActiveSupport::TestCase
    test 'job_arguments returns the arguments of the job' do
      rush_job = RushJob.new
      rush_job.handler = 'test handler'

      assert_equal rush_job.handler, 'test handler'
    end
  end
end
