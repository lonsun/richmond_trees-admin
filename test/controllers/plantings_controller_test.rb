require 'test_helper'

class PlantingsControllerTest < ActionController::TestCase
  setup do
    @planting = plantings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planting" do
    assert_difference('Planting.count') do
      post :create, planting: {  }
    end

    assert_redirected_to planting_path(assigns(:planting))
  end

  test "should show planting" do
    get :show, id: @planting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @planting
    assert_response :success
  end

  test "should update planting" do
    patch :update, id: @planting, planting: {  }
    assert_redirected_to planting_path(assigns(:planting))
  end

  test "should destroy planting" do
    assert_difference('Planting.count', -1) do
      delete :destroy, id: @planting
    end

    assert_redirected_to plantings_path
  end
end
