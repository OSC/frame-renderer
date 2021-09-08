# frozen_string_literal: true

require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test 'create' do
    before = Project.all.size
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test project one',
          description: 'test project one description',
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

  test 'cannot create same name' do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test project one',
          description: 'test project one description',
          directory: tmpdir
        }
      }
      post projects_path, params: params
      id = @response.location.to_s.split('/').last
      assert_redirected_to project_path(id)

      assert_difference('Project.count', 0) do
        post projects_path, params: params
      end
    end
  end

  test 'cannot create invalid directory' do
    params = {
      project: {
        name: 'test project one',
        description: 'test project one description',
        directory: 'tmpdir'
      }
    }
    assert_difference('Project.count', 0) do
      post projects_path, params: params
    end
  end

  test 'deleting_a_project' do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test project one',
          description: 'test project one description',
          directory: tmpdir
        }
      }
      post projects_path, params: params

      id = @response.location.to_s.split('/').last
      assert_difference('Project.count', -1) do
        delete project_path(id)
      end

      follow_redirect!
      assert_response :success
    end
  end

  test 'update a project' do
    Dir.mktmpdir do |tmpdir2|
      Dir.mktmpdir do |tmpdir|
        params = {
          project: {
            name: 'update project',
            desccription: 'project description',
            directory: tmpdir
          }
        }
        new_params = {
          project: {
            name: 'new name',
            desccription: 'new description',
            directory: tmpdir2
          }
        }
        post projects_path, params: params

        id = @response.location.to_s.split('/').last

        get edit_project_path(id)
        assert_response :success

        before = Project.all.size

        put project_path(id), params: new_params
        follow_redirect!
        assert_response :success

        assert_equal('new name', Project.find(id).name)

        after = Project.all.size
        assert_equal(before, after)
      end
    end
  end

  test 'creates a maya project' do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test maya',
          description: 'test project one description',
          directory: tmpdir,
          project_type: 'maya'
        }
      }

      post projects_path, params: params
      id = @response.location.to_s.split('/').last

      follow_redirect!
      assert_response :success

      assert Project.find(id).is_a?(MayaProject)
    end
  end

  test 'creates a vray project' do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test vray',
          description: 'test project one description',
          directory: tmpdir,
          project_type: 'VRay'
        }
      }

      post projects_path, params: params
      id = @response.location.to_s.split('/').last

      follow_redirect!
      assert_response :success

      assert Project.find(id).is_a?(VRayProject)
    end
  end

  test 'handles bad project type input' do
    Dir.mktmpdir do |tmpdir|
      params = {
        project: {
          name: 'test bad input',
          description: 'test project one description',
          directory: tmpdir,
          project_type: 'some other thing'
        }
      }

      post projects_path, params: params
      id = @response.location.to_s.split('/').last

      follow_redirect!
      assert_response :success

      # defaults to creating a MayaProject
      assert Project.find(id).is_a?(MayaProject)
    end
  end
end
