require 'test_helper'

class TutorGroupsControllerTest < ActionController::TestCase
  setup do
    @tutor_group = tutor_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutor_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutor_group" do
    assert_difference('TutorGroup.count') do
      post :create, tutor_group: {  }
    end

    assert_redirected_to tutor_group_path(assigns(:tutor_group))
  end

  test "should show tutor_group" do
    get :show, id: @tutor_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tutor_group
    assert_response :success
  end

  test "should update tutor_group" do
    patch :update, id: @tutor_group, tutor_group: {  }
    assert_redirected_to tutor_group_path(assigns(:tutor_group))
  end

  test "should destroy tutor_group" do
    assert_difference('TutorGroup.count', -1) do
      delete :destroy, id: @tutor_group
    end

    assert_redirected_to tutor_groups_path
  end
end
