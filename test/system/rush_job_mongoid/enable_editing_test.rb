require 'application_system_test_case'

module RushJobMongoid
  class EnableEditingTest < ApplicationSystemTestCase
    test 'changing modes' do
      visit '/rush_job_mongoid/'

      assert_no_button 'Clear'

      click_link 'Options'
      accept_confirm do
        click_button 'Enable Editing'
      end

#      assert_button 'Clear'

      click_link 'Options'
      accept_confirm do
        click_button 'Disable Editing'
      end

#      assert_no_button 'Clear'
    end
  end
end
