require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
	# authenticate
	setup :activate_authlogic

  test "should get index" do
  	UserSession.create(users(:testuser1))

    get :index
    assert_response :success
  end

end
