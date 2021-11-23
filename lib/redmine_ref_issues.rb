# frozen_string_literal: true

module RedmineRefIssues
  VERSION = '1.0.1'

  class << self
    def setup
      Dir[File.join(Redmine::Plugin.find(:redmine_ref_issues).directory,
                    'lib',
                    'redmine_ref_issues',
                    'wiki_macros',
                    '**/*_macro.rb')].sort.each { |f| require f }
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
