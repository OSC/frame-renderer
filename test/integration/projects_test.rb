require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "testing_action_create" do
    before = Project.all.size
    Dir.mktmpdir do |tmpdir|
    params = {
      project: {name: 
                  "test project one", 
                description: 
                  "test project one description", 
                directory: 
                  tmpdir
                }
              }
    post projects_path, params: params
    follow_redirect!
    assert_response :success
    get projects_path
    assert_response :success
    after = Project.all.size
    assert after > before
    end
  end
end