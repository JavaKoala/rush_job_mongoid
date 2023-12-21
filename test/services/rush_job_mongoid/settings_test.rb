require 'test_helper'

module RushJobMongoid
  class SettingsTest < ActiveSupport::TestCase
    test 'change from default' do
      assert_equal Settings.change_setting('theme', nil), 'dark'
    end

    test 'change to default' do
      assert_equal Settings.change_setting('theme', 'dark'), 'light'
    end

    test 'change from named default' do
      assert_equal Settings.change_setting('theme', 'light'), 'dark'
    end

    test 'returns nil for non-existing setting' do
      assert_nil Settings.change_setting('test', 'value')
    end
  end
end
