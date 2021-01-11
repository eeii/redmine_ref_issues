require 'redmine_ref_issues/version'

module RedmineRefIssues
  class << self
    def setup
      require_dependency 'redmine_ref_issues/parser'
      require_dependency 'redmine_ref_issues/macro'
    end
  end
end
