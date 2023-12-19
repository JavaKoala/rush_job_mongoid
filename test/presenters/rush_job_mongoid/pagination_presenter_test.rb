require 'test_helper'

module RushJobMongoid
  class PaginationPresenterTest < ActiveSupport::TestCase
    test 'default page is 1' do
      presenter = PaginationPresenter.new(nil)

      assert_equal presenter.page, 1
    end

    test 'invalid page returns 1' do
      presenter = PaginationPresenter.new('two')

      assert_equal presenter.page, 1
    end

    test 'negative page number' do
      presenter = PaginationPresenter.new(-1)

      assert_equal presenter.page, 1
    end

    test 'page number' do
      presenter = PaginationPresenter.new('1')

      assert_equal presenter.pages(100, 10), 10
    end

    test 'page numbers round up' do
      presenter = PaginationPresenter.new('1')

      assert_equal presenter.pages(101, 10), 11
    end
  end
end
