require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "create" do
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
      assert after = before + 1
      end
  end
  test "deleting_a_project" do
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
      id = @response.location.to_s.split('/').last
      delete project_path(id)
      follow_redirect!
      assert_response :success
      after = Project.all.size
      assert after = before - 1
      end
  end
  test "update a project" do
    Dir.mktmpdir do |tmpdir|
      name = "update project"
      description = "test for updating a project"
      directory = tmpdir
      post projects_path, params: {project: {name: name, description: description, directory: directory}}
      id = @response.location.to_s.split('/').last
      get edit_project_path(id)
      assert_response :success
      before = Project.all.size
      put project_path(id), params: {project: {name: "new name", description: "new description", directory: "same stuff"}}
      follow_redirect!
      assert_response :success
      after = Project.all.size
      assert before == after
    end

  end
end

