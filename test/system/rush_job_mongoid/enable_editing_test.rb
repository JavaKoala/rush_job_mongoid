require 'application_system_test_case'

module RushJobMongoid
  class EnableEditingTest < ApplicationSystemTestCase
    setup do
      DatabaseCleaner.start

      RushJob.create(handler: "--- !ruby/object:ActiveJob::QueueAdapters::DelayedJobAdapter::JobWrapper\n" \
                              "job_data:\n  job_class: TestHandler\n  arguments:\n  - arg1",
                     run_at: Time.zone.now,
                     locked_at: Time.zone.now,
                     locked_by: 'Server1',
                     failed_at: Time.zone.now,
                     last_error: '',
                     queue: 'Queue1')
    end

    teardown do
      DatabaseCleaner.clean
    end

    test 'changing modes' do
      visit '/rush_job_mongoid/'

      assert_no_button 'Clear'

      click_link 'Options'
      accept_confirm do
        click_button 'Enable Editing'
      end

      assert_button 'Clear'

      click_link 'Options'
      accept_confirm do
        click_button 'Disable Editing'
      end

      assert_no_button 'Clear'
    end
  end
end
