module RushJobMongoid
  class QueueGroupsPresenter
    attr_reader :queue_groups_presenter, :rush_job_queue_groups, :queue_groups

    def initialize(queue_groups_page)
      @queue_groups_presenter = PaginationPresenter.new(queue_groups_page)
      @rush_job_queue_groups = RushJob.queue_groups
      @queue_groups = queue_groups_from_presener
    end

    def pages_count
      @queue_groups_presenter.pages(@rush_job_queue_groups.count, 10)
    end

    def page
      @queue_groups_presenter.page
    end

    private

    def queue_groups_from_presener
      @rush_job_queue_groups[(@queue_groups_presenter.page - 1) * 10, 10]
    end
  end
end
