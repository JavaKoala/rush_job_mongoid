module RushJobMongoid
  class Settings
    RUSH_JOB_SETTINGS = {
      theme: %w[light dark]
    }.freeze

    def self.change_setting(setting, value)
      return unless RUSH_JOB_SETTINGS[setting.to_sym]

      if RUSH_JOB_SETTINGS[setting.to_sym].include?(value)
        (RUSH_JOB_SETTINGS[setting.to_sym] - [value]).first
      else
        RUSH_JOB_SETTINGS[setting.to_sym].last
      end
    end
  end
end
