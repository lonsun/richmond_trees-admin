require 'test_helper'

class HomepageControllerTest < ActionController::TestCase
  # authenticate
  setup :activate_authlogic

  describe "when the user logs in" do
    it "goes to the homepage when there is a valid session" do
      UserSession.create(users(:testuser1))
      get :index
      
      assert_response :success
      assert_template 'index'
    end

    it "fails without a valid session and redirects to the login page" do
      get :index

      assert_response :redirect
      assert_redirected_to root_url
    end
  end

end
