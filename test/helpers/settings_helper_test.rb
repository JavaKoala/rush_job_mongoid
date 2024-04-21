require 'test_helper'

module RushJobMongoid
  class SettingsHelperTest < ActionView::TestCase
    test 'returns light for the default theme' do
      assert_equal current_theme, 'light'
    end

    test 'returns dark for the dark theme' do
      cookies[:rush_job_theme] = 'dark'

      assert_equal current_theme, 'dark'
    end

    test 'returns dark for the inverted default theme' do
      assert_equal invert_theme, 'dark'
    end

    test 'returns light for the inverted dark theme' do
      cookies[:rush_job_theme] = 'dark'

      assert_equal invert_theme, 'light'
    end

    test 'returns false for editing default' do
      assert_equal editing_enabled?, false
    end

    test 'returns true for the editing enabled' do
      cookies[:rush_job_editing] = 'enabled'

      assert_equal editing_enabled?, true
    end

    test 'returns false for the editing disabled' do
      cookies[:rush_job_editing] = 'disabled'

      assert_equal editing_enabled?, false
    end

    test 'returns true for queue groups default' do
      assert_equal queue_groups_enabled?, true
    end

    test 'returns true for queue groups enabled' do
      cookies[:rush_job_queue_groups_presenter] = 'enabled'

      assert_equal queue_groups_enabled?, true
    end

    test 'returns false for queue groups disabled' do
      cookies[:rush_job_queue_groups_presenter] = 'disabled'

      assert_equal queue_groups_enabled?, false
    end
  end
end
