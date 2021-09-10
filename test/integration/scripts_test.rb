# frozen_string_literal: true

require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  def new_project(dir, type: 'Maya')
    params = {
      project: {
        name: ('a'..'z').to_a.shuffle[0,8].join,
        description: 'test project',
        directory: dir,
        project_type: type
      }
    }

    post projects_path, params: params
    # for some reason you need to get the id before you follow redirect
    id = @response.location.to_s.split('/').last

    follow_redirect!
    assert_response :success

    id
  end

  def script_params(overrides: {})
    # TODO: looks like the controller only validates the frames. everything else is required in the js
    {
      script: {
        frames: '1-10'
      }.deep_merge!(overrides)
    }
  end

  test 'maya project creates maya script' do
    Dir.mktmpdir do |tmpdir|
      id = new_project(tmpdir)
      get project_path(id)
      assert_response :success

      get new_project_script_path(id)
      assert_response :success

      post project_scripts_path(id), params: script_params
      follow_redirect!
      assert_response :success

      assert_select 'div.alert-success', 1
      assert_select 'div.alert-danger', 0

      assert_select 'tbody tr', 1
      assert_equal 1, Project.find(id).scripts.length
      assert_equal true, Project.find(id).scripts[0].is_a?(MayaScript)
    end
  end

  test 'vray project creates vray script' do
    Dir.mktmpdir do |tmpdir|
      id = new_project(tmpdir, type: 'vray')
      get project_path(id)
      assert_response :success

      get new_project_script_path(id)
      assert_response :success

      post project_scripts_path(id), params: script_params
      follow_redirect!
      assert_response :success

      assert_select 'div.alert-success', 1
      assert_select 'div.alert-danger', 0

      assert_select 'tbody tr', 1
      assert_equal 1, Project.find(id).scripts.length
      assert_equal true, Project.find(id).scripts[0].is_a?(VRayScript)
    end
  end
end