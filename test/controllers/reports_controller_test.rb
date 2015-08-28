require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
  end

  it "should respond to csv format" do
    params = { :format => :csv,
      "planted_on_from" => "",
      "planted_on_to" => "",
      "last_maintenance_from" => "",
      "last_maintenance_to" => "",
      "tree_id" => [ 1 ],
      "last_status_codes" => [],
      "note" => "",
      "include_nil_maintenance_records" => "yes",
      "house_number_gt" => "",
      "house_number_lt" => "",
      "stakes_removed" => "ignore"
    }

    get 'plantings_results', params
    assert_response :success
  end

  it "should route to plantings report" do
    get 'plantings'
    assert_equal @controller.controller_name, 'reports'
    assert_equal @controller.action_name, 'plantings'
    assert_response :success
  end
end
