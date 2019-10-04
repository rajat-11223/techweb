require 'test_helper'

class LearningGroupsControllerTest < ActionController::TestCase
  setup do
    @learning_group = learning_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:learning_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create learning_group" do
    assert_difference('LearningGroup.count') do
      post :create, learning_group: {  }
    end

    assert_redirected_to learning_group_path(assigns(:learning_group))
  end

  test "should show learning_group" do
    get :show, id: @learning_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @learning_group
    assert_response :success
  end

  test "should update learning_group" do
    patch :update, id: @learning_group, learning_group: {  }
    assert_redirected_to learning_group_path(assigns(:learning_group))
  end

  test "should destroy learning_group" do
    assert_difference('LearningGroup.count', -1) do
      delete :destroy, id: @learning_group
    end

    assert_redirected_to learning_groups_path
  end
end
