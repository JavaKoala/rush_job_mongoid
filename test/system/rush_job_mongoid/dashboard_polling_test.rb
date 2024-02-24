require 'application_system_test_case'

module RushJobMongoid
  class DashboardPollingTest < ApplicationSystemTestCase
    test 'dashboard polling' do
      visit '/rush_job_mongoid'

      assert_text 'Polling time: 13 seconds'

      find(:xpath, "//input[@id='rush-job-mongoid-polling-range']").set 0

      assert_text 'Polling time: 3 seconds'
    end
  end
end
