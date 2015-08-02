require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get params" do
    get :params
    assert_response :success
  end

  test "should get suitable" do
    get :suitable
    assert_response :success
  end

end
