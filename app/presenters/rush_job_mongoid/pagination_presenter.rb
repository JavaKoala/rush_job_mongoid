module RushJobMongoid
  class PaginationPresenter
    def initialize(page_param)
      @page_param = page_param
    end

    def page
      page = @page_param&.to_i || 1

      page < 1 ? 1 : page
    end

    def pages(item_count, items_per_page)
      (item_count / items_per_page.to_f).ceil
    end
  end
end
