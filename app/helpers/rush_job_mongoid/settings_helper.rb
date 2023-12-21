module RushJobMongoid
  module SettingsHelper
    def current_theme
      cookies[:rush_job_theme] == 'dark' ? 'dark' : 'light'
    end
  end
end
