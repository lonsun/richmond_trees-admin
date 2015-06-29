require 'test_helper'

class PlantingsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))

    @planting = plantings(:one)
  end

  # TODO: Find a way to make this test work with parent associations...
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:plantings)
  # end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planting" do
    assert_difference('Planting.count') do
      post :create, planting: { adoption_request_id: @planting.adoption_request_id, 
        tree_id: @planting.tree_id, 
        plant_space_width: @planting.plant_space_width }
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
    patch :update, id: @planting, planting: { adoption_request_id: @planting.adoption_request_id, 
      tree_id: @planting.tree_id, 
      plant_space_width: @planting.plant_space_width }
    assert_redirected_to planting_path(assigns(:planting))
  end

  test "should destroy planting" do
    assert_difference('Planting.count', -1) do
      delete :destroy, id: @planting
    end

    assert_redirected_to plantings_path
  end
end
