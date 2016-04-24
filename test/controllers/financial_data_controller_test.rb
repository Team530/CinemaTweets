require 'test_helper'

class FinancialDataControllerTest < ActionController::TestCase
  setup do
    @financial_datum = financial_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:financial_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create financial_datum" do
    assert_difference('FinancialDatum.count') do
      post :create, financial_datum: {  }
    end

    assert_redirected_to financial_datum_path(assigns(:financial_datum))
  end

  test "should show financial_datum" do
    get :show, id: @financial_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @financial_datum
    assert_response :success
  end

  test "should update financial_datum" do
    patch :update, id: @financial_datum, financial_datum: {  }
    assert_redirected_to financial_datum_path(assigns(:financial_datum))
  end

  test "should destroy financial_datum" do
    assert_difference('FinancialDatum.count', -1) do
      delete :destroy, id: @financial_datum
    end

    assert_redirected_to financial_data_path
  end
end
