require 'application_system_test_case'

module RushJobMongoid
  class ThemeTest < ApplicationSystemTestCase
    test 'changing modes' do
      visit '/rush_job_mongoid'

      assert_selector 'body[data-bs-theme="light"]'

      click_link 'Options'
      click_button 'Dark Mode'

      assert_selector 'body[data-bs-theme="dark"]'

      click_link 'Options'
      assert_no_button 'Dark Mode'
      assert_button 'Light Mode'

      refresh

      assert_selector 'body[data-bs-theme="dark"]'

      click_link 'Options'
      click_button 'Light Mode'

      assert_selector 'body[data-bs-theme="light"]'
    end
  end
end
