require 'application_system_test_case'

module RushJob
  class RushJobsPaginationTest < ApplicationSystemTestCase
    test 'No pagination for a single page' do
      visit '/rush_job_mongoid'

      assert_no_selector '.pagination'
    end
  end
end
