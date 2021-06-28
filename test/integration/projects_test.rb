require "test_helper"

class ProjectsTest < ActionDispatch::IntegrationTest
  test "create" do
    before = Project.all.size
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: "test project one",
          description: "test project one description",
          directory: tmpdir
        }
      }
      post projects_path, params: params
      follow_redirect!
      assert_response :success

      get projects_path
      assert_response :success

      after = Project.all.size
      assert after == before + 1
    end
  end
  test "cannot create same name" do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: "sample name",
          description: "test project one description",
          directory: tmpdir
        }
      }
      new_params = {
        project: {
          name: "sample name",
          description: "test project one description",
          directory: tmpdir
        }
      }
      post projects_path, params: params
      follow_redirect!
      assert_response :success

      get projects_path
      assert_response :success

      post projects_path, params: new_params
      assert_response :success

      get projects_path
      assert_response :success
    end
  end
  test "cannot create invalid directory" do

  end
  test "deleting_a_project" do
    before = Project.all.size
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: "test project one",
          description: "test project one description",
          directory: tmpdir
        }
      }
      post projects_path, params: params

      id = @response.location.to_s.split("/").last

      delete project_path(id)
      follow_redirect!
      assert_response :success

      after = Project.all.size
      assert after = before -1
    end
  end
  test "update a project" do
    Dir.mktmpdir do |tmpdir2|
      Dir.mktmpdir do |tmpdir|
        params = {
          project: {
            name: "update project",
            desccription: "project description",
            directory: tmpdir
          }
        }
        new_params = {
          project: {
            name: "new name",
            desccription: "new description",
            directory: tmpdir2
          }
        }
        post projects_path, params: params
      
        id = @response.location.to_s.split("/").last
      
        get edit_project_path(id)
        assert_response :success

        before = Project.all.size

        put project_path(id), params: new_params
        follow_redirect!
        assert_response :success

        after = Project.all.size
        assert_equal(before, after)
      end
    end
  end
end
