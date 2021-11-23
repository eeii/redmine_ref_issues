# frozen_string_literal: true

raise "\n\033[31maredmine_ref_issues requires ruby 2.6 or newer. Please update your ruby version.\033[0m" if RUBY_VERSION < '2.6'

Redmine::Plugin.register :redmine_ref_issues do
  name 'Redmine ref_issues macro'
  author 'AlphaNodes GmbH'
  description 'Wiki macro to list issues.'
  version RedmineRefIssues::VERSION
  url 'https://github.com/alphanodes/redmine_ref_issues'
  author_url 'https://alphanodes.com/'
  directory __dir__

  requires_redmine version_or_higher: '4.1'
end

if Rails.version > '6.0'
  ActiveSupport.on_load(:active_record) { RedmineRefIssues.setup }
else
  Rails.configuration.to_prepare { RedmineRefIssues.setup }
end
