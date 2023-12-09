module RushJobMongoid
  class DashboardController < ApplicationController
    def index
      @queue_groups = RushJob.queue_groups
    end
  end
end
