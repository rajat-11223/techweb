require 'test_helper'

class YearlyTermsControllerTest < ActionController::TestCase
  setup do
    @yearly_term = yearly_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yearly_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yearly_term" do
    assert_difference('YearlyTerm.count') do
      post :create, yearly_term: {  }
    end

    assert_redirected_to yearly_term_path(assigns(:yearly_term))
  end

  test "should show yearly_term" do
    get :show, id: @yearly_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yearly_term
    assert_response :success
  end

  test "should update yearly_term" do
    patch :update, id: @yearly_term, yearly_term: {  }
    assert_redirected_to yearly_term_path(assigns(:yearly_term))
  end

  test "should destroy yearly_term" do
    assert_difference('YearlyTerm.count', -1) do
      delete :destroy, id: @yearly_term
    end

    assert_redirected_to yearly_terms_path
  end
end
