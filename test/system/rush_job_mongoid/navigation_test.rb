require 'application_system_test_case'

module RushJobMongoid
  class NavigationTest < ApplicationSystemTestCase
    test 'root path' do
      visit '/rush_job_mongoid/'

      assert_selector 'h3', text: 'Queues'
    end

    test 'navigate to jobs page' do
      visit '/rush_job_mongoid/'
      click_link 'Jobs'

      assert_selector 'h3', text: 'Delayed Jobs'
      find_link('Dashboard', class: 'nav-link')
      find_link('Jobs', class: 'nav-link active')
    end

    test 'navigate to dashboard' do
      visit '/rush_job_mongoid/'
      click_link 'Jobs'
      click_link 'Dashboard'

      assert_selector 'h3', text: 'Queues'
      find_link('Dashboard', class: 'nav-link active')
      find_link('Jobs', class: 'nav-link')
    end

    test 'navigate to root path' do
      visit '/rush_job_mongoid/'
      click_link 'Jobs'
      click_link 'Delayed Jobs'

      assert_selector 'h3', text: 'Queues'
    end
  end
end
