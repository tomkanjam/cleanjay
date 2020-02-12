require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { a1rate: @profile.a1rate, a2rate: @profile.a2rate, a3rate: @profile.a3rate, description: @profile.description, h1rate: @profile.h1rate, h2rate: @profile.h2rate, h3rate: @profile.h3rate, name: @profile.name }
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile" do
    put :update, id: @profile, profile: { a1rate: @profile.a1rate, a2rate: @profile.a2rate, a3rate: @profile.a3rate, description: @profile.description, h1rate: @profile.h1rate, h2rate: @profile.h2rate, h3rate: @profile.h3rate, name: @profile.name }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end

    assert_redirected_to profiles_path
  end
end
