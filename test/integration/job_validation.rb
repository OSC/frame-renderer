require 'test-helper'
class ProjectsTest < ActionDispatch::IntegrationTest
    #A script can have many jobs
    #A job is dependent on a script

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
    def new_script (dir)
      Dir.mktmpdir do |tmpdir|
        id = new_project(tmpdir)
        get project_path(id)
        assert_response :success
  
        get new_project_script_path(id)
        assert_response :success
  
        post project_scripts_path(id), params: script_params
        follow_redirect!
        assert_response :success
        

    end
    test 'deleting a script deletes a job' do
      
    end

end
