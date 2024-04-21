require 'application_system_test_case'

module RushJobMongoid
  class EnableQueuesTest < ApplicationSystemTestCase
    test 'enabling and disabling queues' do
      visit '/rush_job_mongoid/'

      assert_text 'Queues'

      click_link 'Options'
      click_button 'Disable Queues'

      assert_no_text 'Queues'

      click_link 'Options'
      click_button 'Enable Queues'

      assert_text 'Queues'
    end
  end
end
