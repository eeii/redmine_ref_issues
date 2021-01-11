require File.expand_path '../../test_helper', __FILE__

class WikiControllerTest < RedmineRefIssues::ControllerTest
  fixtures :users, :email_addresses, :roles,
           :enumerations,
           :projects, :projects_trackers, :enabled_modules,
           :members, :member_roles,
           :trackers,
           :groups_users,
           :issue_statuses, :issues, :issue_categories,
           :custom_fields, :custom_values, :custom_fields_trackers,
           :wikis, :wiki_pages, :wiki_contents,
           :queries

  def setup
    @project = projects :projects_001
    @wiki = @project.wiki
    @page_name = 'ref_issues_macro_test'
    @page = @wiki.find_or_new_page @page_name
    @page.content = WikiContent.new
    @page.content.text = 'test'
    @page.save!

    @default_test_macro = '{{ref_issues(-f:subject ~ sorting)}}'
  end

  def test_show_with_ref_issues_macro
    @request.session[:user_id] = 2

    macro_options = ['-i=1',
                     '-q=Public query for all projects',
                     '-f:subject ~ sorting',
                     '-f:author_id = 1, -f:status ! New, project, subject, author, assigned_to, status',
                     '-f:tracker == Bug | Feature request, -f:project = eCookbook',
                     '-f:issue_id >< 1|5',
                     '-f:issue_id == 1|3',
                     '-f:category == Printing|Recipes, subject, category',
                     '-f:treated jsmith 2017-05-01|[1days_ago]']

    macro_options.each do |macro_option|
      text = "{{ref_issues(#{macro_option})}}"
      @page.content.text = text
      assert_save @page.content

      get :show,
          params: { project_id: 1, id: @page_name }

      assert_response :success
      # puts macro_option
      assert_select 'table.list.issues'
    end
  end

  def test_ref_issues_with_zero_option
    @request.session[:user_id] = 2
    @page.content.text = '{{ref_issues(-0,-f:subject = Cannot print recipes2)}}'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'table.list.issues', count: 0
  end

  def test_ref_issues_with_linked_id
    @request.session[:user_id] = 2
    @page.content.text = '{{ref_issues(-f:subject = Add ingredients categories, -l=id)}}'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'div.wiki.wiki-page a[href="/issues/2"]'
  end

  def test_ref_issues_with_description
    @request.session[:user_id] = 2
    @page.content.text = '{{ref_issues(-f:subject = Add ingredients categories, -t=description)}}'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'div.wiki.wiki-page',
                  text: /Ingredients of the recipe should be classified by categories/
  end

  def test_ref_issues_with_count
    @request.session[:user_id] = 2
    @page.content.text = '{{ref_issues(-f:subject ~ recipe, -c)}}'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'div.wiki.wiki-page',
                  text: /2/
  end

  def test_ref_issues_with_sum
    @request.session[:user_id] = 2
    @page.content.text = '{{ref_issues(-f:subject ~ recipe, -sum:estimated_hours)}}'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'div.wiki.wiki-page',
                  text: /201/
  end

  def test_multiple_ref_issues_macros
    @request.session[:user_id] = 2

    @page.content.text = "#{@default_test_macro} and #{@default_test_macro} and #{@default_test_macro}"
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'table.list.issues'
  end

  def test_ref_issues_macro_without_issue_permission
    @request.session[:user_id] = 8

    Role.all.each { |r| r.remove_permission!(:view_issues) }
    User.current = User.find(8)

    assert User.current.allowed_to?(:view_wiki_pages, @project)
    assert_not User.current.allowed_to? :view_issues, @project

    @page.content.text = '-0,-f:subject = Cannot print recipes'
    assert_save @page.content

    get :show,
        params: { project_id: 1, id: @page_name }

    assert_response :success
    assert_select 'table.list.issues', count: 0
  end
end
