require File.expand_path "#{File.dirname __FILE__}/../../../test/test_helper"

module RedmineRefIssues
  module TestHelper
  end

  class ControllerTest < Redmine::ControllerTest
    include RedmineRefIssues::TestHelper
  end

  class TestCase < ActiveSupport::TestCase
    include RedmineRefIssues::TestHelper
  end
end
