require 'test_helper'

class CorpStatesControllerTest < ActionController::TestCase
  setup do
    @corp_state = corp_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corp_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create corp_state" do
    assert_difference('CorpState.count') do
      post :create, corp_state: { state: @corp_state.state }
    end

    assert_redirected_to corp_state_path(assigns(:corp_state))
  end

  test "should show corp_state" do
    get :show, id: @corp_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @corp_state
    assert_response :success
  end

  test "should update corp_state" do
    put :update, id: @corp_state, corp_state: { state: @corp_state.state }
    assert_redirected_to corp_state_path(assigns(:corp_state))
  end

  test "should destroy corp_state" do
    assert_difference('CorpState.count', -1) do
      delete :destroy, id: @corp_state
    end

    assert_redirected_to corp_states_path
  end
end
