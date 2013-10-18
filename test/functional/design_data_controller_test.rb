require 'test_helper'

class DesignDataControllerTest < ActionController::TestCase
  setup do
    @design_datum = design_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:design_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create design_datum" do
    assert_difference('DesignDatum.count') do
      post :create, design_datum: { attr: @design_datum.attr, corp_comment: @design_datum.corp_comment, ctype: @design_datum.ctype, curSeq_id: @design_datum.curSeq_id, design_comment: @design_datum.design_comment, designer: @design_datum.designer, file_name: @design_datum.file_name, memo: @design_datum.memo, thumbnail: @design_datum.thumbnail, up_date: @design_datum.up_date }
    end

    assert_redirected_to design_datum_path(assigns(:design_datum))
  end

  test "should show design_datum" do
    get :show, id: @design_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @design_datum
    assert_response :success
  end

  test "should update design_datum" do
    put :update, id: @design_datum, design_datum: { attr: @design_datum.attr, corp_comment: @design_datum.corp_comment, ctype: @design_datum.ctype, curSeq_id: @design_datum.curSeq_id, design_comment: @design_datum.design_comment, designer: @design_datum.designer, file_name: @design_datum.file_name, memo: @design_datum.memo, thumbnail: @design_datum.thumbnail, up_date: @design_datum.up_date }
    assert_redirected_to design_datum_path(assigns(:design_datum))
  end

  test "should destroy design_datum" do
    assert_difference('DesignDatum.count', -1) do
      delete :destroy, id: @design_datum
    end

    assert_redirected_to design_data_path
  end
end
