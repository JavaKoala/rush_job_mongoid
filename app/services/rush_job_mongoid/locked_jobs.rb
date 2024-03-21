module RushJobMongoid
  class LockedJobs
    def initialize(filters = {})
      @filters = filters
    end

    def jobs
      RushJob.filter(@filters).locked_jobs
    end

    def paginate(page, count_per_page = 10)
      jobs.locked_by_desc.paginate(page, count_per_page)
    end
  end
end
