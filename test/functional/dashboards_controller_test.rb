require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  test "should get overview" do
    get :overview
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

end
