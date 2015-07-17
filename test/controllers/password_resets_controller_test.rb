require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  setup do
    @user = users( :testuser1 )
  end

  describe "on GET to :new" do
    it "it successfully renders the password reset page" do
      get :new

      assert_response :success
      assert_template :new
    end
  end

  describe "on POST to :create" do
    it "sends a password reset email and redirects the user to the login page" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        post :create, :username => @user.username
      end

      pr_email = ActionMailer::Base.deliveries.last
      pr_email.subject.must_equal "Richmond Trees - Password Reset Instructions"

      assigns( :user ).must_be_instance_of User
      assert_response :redirect
      assert_redirected_to root_path
    end

    it "treats the username as case insensitive" do
      post :create, :username => @user.username.upcase

      assigns( :user ).must_be_instance_of User
      assert_response :redirect
      assert_redirected_to root_path
    end

    it "fails and shows the initiate password reset page if the username is not found" do
      post :create, :username => "not_a_real_user"

      assigns( :user ).must_be_nil
      assert_response :success
      assert_template 'new'
    end
  end

  describe "on GET to :edit" do
    it "shows the create a password page" do
      get :edit, :id => @user.perishable_token
        
      assigns( :user ).must_be_instance_of User
      assert_response :success
      assert_template 'edit'
    end
  end

  describe "on PUT to :update" do
    it "behaves as if the user's password was successfully updated and logs the person in automatically" do
      put :update, { id: @user.perishable_token,
                     password: "password",
                     password_confirmation: "password" }

      assigns( :user ).must_be_instance_of User
      assert_response :redirect
      assert_redirected_to home_path
    end

    it "fails if the password and password confirmation don't match" do
      put :update, { id: @user.perishable_token,
                     password: "password",
                     password_confirmation: "123456" }

      assigns( :user ).errors.size.must_equal 1
      assert_response :success
      assert_template 'edit'
    end
  end
end
