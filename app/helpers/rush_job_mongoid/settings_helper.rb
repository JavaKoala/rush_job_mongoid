module RushJobMongoid
  module SettingsHelper
    def current_theme
      cookies[:rush_job_theme] == 'dark' ? 'dark' : 'light'
    end

    def invert_theme
      cookies[:rush_job_theme] == 'dark' ? 'light' : 'dark'
    end

    def editing_enabled?
      cookies[:rush_job_editing] == 'enabled'
    end

    def queue_groups_enabled?
      cookies[:rush_job_queue_groups_presenter] != 'disabled'
    end
  end
end
