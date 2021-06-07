require 'test_helper'



class ProjectsTest < ActionDispatch::IntegrationTest
  #PATH = "orange"
  #
  #test "sandbox_apps_accessible_if_app_development_enabled" do
  #  Dir.mktmpdir do |dir|
  #    Configuration.stubs(:app_development_enabled?).returns(true)
  #    Configuration.stubs(:dev_apps_root_path).returns(Pathname.new(dir))
#
  #    get "/admin/dev/products"
  #    assert_response :success
  #  end
  #end
#
  #test "sandbox_apps_not_accessible_if_app_development_disabled" do
  #  Configuration.stubs(:app_development_enabled?).returns(false)
#
  #  assert_raises(ActionController::RoutingError) do
  #    get "/admin/dev/products"
  #  end
  #end
#
  #test "new_project_shows_up_on_view" do
  #  get "/projects/new"
  #  assert_response :success
  #  #follow_redirect!
  #  post "/projects/new",
  #  params: { project: { name: "can create", description: "project successfully.", directory: "/users/PZS0715/bluitel/maya/projects/"} }
  #  assert_response :redirect
  #  follow_redirect!
  #  assert_response :success
  #  get "/projects"
  #  assert_select "tbody", "Project Name:\n  can create"
  #end
  #test "deleting_project" do
  #  get ""
  #end
  test "testing_controller_action_create" do
    postVar = post projects_url, 
    params: { project: { name: "can create", description: "project successfully.", directory: "/users/PZS0715/bluitel/maya/projects/"} }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
  #test "deleting_projects_gets_removed" do
  #  delete "/projects/4"
  #end
end