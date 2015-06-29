require 'test_helper'

class MaintenanceRecordsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
    
    @maintenance_record = maintenance_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintenance_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create maintenance_record" do
    assert_difference('MaintenanceRecord.count') do
      post :create, maintenance_record: { planting_id: @maintenance_record.planting_id,
        status_code: @maintenance_record.status_code,
        reason_codes: "a,b,c",
        diameter_breast_height: "2",
        maintenance_date: @maintenance_record.maintenance_date }
    end

    assert_response :redirect
  end

  test "should show maintenance_record" do
    get :show, id: @maintenance_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @maintenance_record
    assert_response :success
  end

  test "should update maintenance_record" do
    patch :update, id: @maintenance_record, maintenance_record: { planting_id: @maintenance_record.planting_id,
        status_code: @maintenance_record.status_code,
        reason_codes: "a,b,c",
        diameter_breast_height: "2" }
    assert_response :redirect
  end

  test "should destroy maintenance_record" do
    assert_difference('MaintenanceRecord.count', -1) do
      delete :destroy, id: @maintenance_record
    end

    assert_response :redirect
  end
end
