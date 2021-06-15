require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "testing_action_create" do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: { name: 
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
    
  end
end
  test "cannot_create_without_valid_directory" do
  params = {
    project: { name: 
                "test project two", 
               description: 
                "test project two description", 
               directory: 
                "tmpdir/"
    }
  }
  post projects_path, params: params
  !assert_response :success
  get projects_path
  assert_not :success
  end

  test "cannot_create_two_projects_with_same_name" do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: { name: 
                    "test project three", 
                   description: 
                    "test project three description", 
                   directory: 
                    tmpdir
        }
      }
      post projects_path, params: params
      follow_redirect!
      assert_response :success
      get projects_path
      assert_response :success
      params2 = {
        project: { name: 
                    "test project three", 
                   description: 
                    "test project three description", 
                   directory: 
                    tmpdir
        }
      }
      post projects_path, params: params
      !assert_response :success
  end
end
end