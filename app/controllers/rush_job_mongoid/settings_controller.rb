module RushJobMongoid
  class SettingsController < ApplicationController
    def update
      change_setting if Settings::RUSH_JOB_SETTINGS[params[:setting]&.to_sym]

      redirect_to root_path
    end

    private

    def change_setting
      setting_param = params[:setting]
      setting_cookie = "rush_job_#{setting_param}"

      cookies.permanent[setting_cookie.to_sym] = Settings.change_setting(setting_param, cookies[setting_cookie.to_sym])
    end
  end
end
