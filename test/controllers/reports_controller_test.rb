require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
  end

  it "should route to plantings report" do
    get 'plantings'
    assert_equal @controller.controller_name, 'reports'
    assert_equal @controller.action_name, 'plantings'
    assert_response :success
  end
end
