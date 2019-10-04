require 'test_helper'

class StaffProfilesControllerTest < ActionController::TestCase
  setup do
    @staff_profile = staff_profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staff_profile" do
    assert_difference('StaffProfile.count') do
      post :create, staff_profile: {  }
    end

    assert_redirected_to staff_profile_path(assigns(:staff_profile))
  end

  test "should show staff_profile" do
    get :show, id: @staff_profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @staff_profile
    assert_response :success
  end

  test "should update staff_profile" do
    patch :update, id: @staff_profile, staff_profile: {  }
    assert_redirected_to staff_profile_path(assigns(:staff_profile))
  end

  test "should destroy staff_profile" do
    assert_difference('StaffProfile.count', -1) do
      delete :destroy, id: @staff_profile
    end

    assert_redirected_to staff_profiles_path
  end
end
