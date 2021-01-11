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

Rails.configuration.to_prepare do
  RedmineRefIssues.setup
end
