# frozen_string_literal: true

module RedmineRefIssues
  VERSION = '1.0.1'

  class << self
    def setup
      Additionals.load_macros 'redmine_ref_issues'
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
