require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test 'index always shows' do
    get :index
    assert_response :success
  end
end
