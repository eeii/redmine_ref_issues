# frozen_string_literal: true

require 'redmine_ref_issues/version'

module RedmineRefIssues
  class << self
    def setup
      require_dependency 'redmine_ref_issues/parser'
      require_dependency 'redmine_ref_issues/macro'
    end

    def cast_table_field(db_table, db_field)
      if Redmine::Database.postgresql?
        "CAST(#{db_table}.#{db_field} AS TEXT)"
      else
        "#{db_table}.#{db_field}"
      end
    end

    def additionals_help_items
      [{ title: 'Redmine ref_issues macro',
         url: 'https://github.com/AlphaNodes/redmine_ref_issues#usage' }]
    end
  end
end
