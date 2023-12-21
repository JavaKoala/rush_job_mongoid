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
  end
end
