# frozen_string_literal: true

require File.expand_path "#{File.dirname __FILE__}/../../../test/test_helper"

module RedmineRefIssues
  module TestHelper
  end

  class ControllerTest < Redmine::ControllerTest
    include RedmineRefIssues::TestHelper

    def prepare_macro_page(text)
      @page = @wiki.find_or_new_page @page_name
      @page.content = WikiContent.new
      @page.content.text = text

      assert_save @page
    end

    def assert_ref_issues_macro(text: nil, count: 1)
      if text.present?
        assert_select 'table.list.issues', text: /#{text}/, count: count
      else
        assert_select 'table.list.issues', count: count
      end
    end
  end

  class TestCase < ActiveSupport::TestCase
    include RedmineRefIssues::TestHelper
  end
end
