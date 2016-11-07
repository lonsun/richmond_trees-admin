require 'test_helper'

class MaintenanceRecordsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))

    @maintenance_record = maintenance_records(:one)
    @user = users(:testuser1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maintenance_records)
  end

  test "should get new" do
    # maintenance records are always associated with a planting
    get :new, { :planting_id => 1 }
    assert_response :success
  end

  describe "when creating a maintenance_record" do
    it "creates one" do
      assert_difference('MaintenanceRecord.count') do
        post :create,
          maintenance_record: {
            planting_id: @maintenance_record.planting_id,
            status_code: @maintenance_record.status_code,
            reason_codes: "a,b,c",
            diameter_breast_height: "2",
            maintenance_date: @maintenance_record.maintenance_date,
            user_id: @user.id
          },
          mark_stakes_removed: false
      end

      assert_not @maintenance_record.planting.stakes_removed

      assert_response :redirect
    end

   it "updates stakes_removed flag on the associated planting " do
      assert_difference('MaintenanceRecord.count') do
        post :create,
          maintenance_record: {
            planting_id: @maintenance_record.planting_id,
            status_code: @maintenance_record.status_code,
            reason_codes: ["a,b,c"],
            diameter_breast_height: "2",
            maintenance_date: @maintenance_record.maintenance_date,
            user_id: @user.id
          },
          mark_stakes_removed: "1"
      end

      assert @maintenance_record.planting.stakes_removed

      assert_response :redirect
    end

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
    patch :update, id: @maintenance_record, maintenance_record: {
      planting_id: @maintenance_record.planting_id,
      status_code: @maintenance_record.status_code,
      reason_codes: ["a,b,c"],
      diameter_breast_height: "2",
      user_id: @user.id }
    assert_response :redirect
  end

  describe "when deleting an maintenance_record" do
    it "should be deleted when passed a \"hard_delete\" parameter with the value of \"yes\"" do
      assert_difference('MaintenanceRecord.count', -1) do
        delete :destroy, { id: @maintenance_record, "hard_delete" => "yes" }
      end

      assert_redirected_to controller: "plantings", action: "show",
        id: @maintenance_record.planting_id
    end

    it "should be marked as ignored by default" do
      assert_difference('MaintenanceRecord.count', 0) do
        delete :destroy, id: @maintenance_record
      end

      ar = MaintenanceRecord.find(@maintenance_record.id)
      assert_equal true, ar.ignore
      assert_redirected_to controller: "plantings", action: "show",
        id: @maintenance_record.planting_id
    end
  end

  describe "when attempting to access an ignored record" do
    it "should be treated as if it doesn't exist" do
      ignored = maintenance_records( :ignored )
      assert_raises( ActiveRecord::RecordNotFound ) { get :show, id: ignored }
    end
  end

end
