require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))

    @user = users(:testuser1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user:
        { first_name: "test",
          last_name: "user2",
          username: "testuser2",
          email: "testuser2@test.com" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user:
      { username: @user.username,
        email: @user.email,
        password: "password",
        password_confirmation: "password" }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not destroy user with foreign key references" do
    assert_no_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

  test "should destroy user with no foreign key references" do
    assert_difference('User.count', -1) do
      delete :destroy, id: users(:no_references)
    end

    assert_redirected_to users_path
  end
end
