require 'test_helper'

class AdoptionRequestsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
    
    @adoption_request = adoption_requests(:one)
    @user = users(:testuser1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adoption_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adoption_request" do
    assert_difference('AdoptionRequest.count') do
      post :create, adoption_request: { 
        "received_on" => "2015-01-01",
        "owner_first_name" => @adoption_request.owner_first_name, 
        "house_number" => @adoption_request.house_number, 
        "street_name" => @adoption_request.street_name,
        user_id: @user.id }
    end

    assert_redirected_to adoption_request_path(assigns(:adoption_request))
  end

  test "should show adoption_request" do
    get :show, id: @adoption_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @adoption_request
    assert_response :success
  end

  test "should update adoption_request" do
    patch :update, id: @adoption_request, adoption_request: { 
      "received_on" => "2015-01-01",
      "owner_first_name" => @adoption_request.owner_first_name, 
      "house_number" => @adoption_request.house_number, 
      "street_name" => @adoption_request.street_name,
      :user_id => @user.id }
    assert_redirected_to adoption_request_path(assigns(:adoption_request))
  end

  test "should destroy adoption_request" do
    assert_difference('AdoptionRequest.count', -1) do
      delete :destroy, id: @adoption_request
    end

    assert_redirected_to adoption_requests_path
  end
end
