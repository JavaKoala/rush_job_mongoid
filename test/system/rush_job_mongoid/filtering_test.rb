require 'application_system_test_case'

module RushJobMongoid
  class FilteringTest < ApplicationSystemTestCase
    test 'root path' do
      visit '/rush_job_mongoid/'

      click_link 'Filter'

      assert_text 'Filter jobs'

      click_button 'Close'
    end
  end
end
