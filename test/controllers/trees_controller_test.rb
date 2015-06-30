require 'test_helper'

class TreesControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
    
    @tree = trees(:one)
    @user = users(:testuser1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tree" do
    assert_difference('Tree.count') do
      post :create, tree: { common_name: @tree.common_name, 
        family_name: @tree.family_name, 
        scientific_name: @tree.scientific_name,
        user_id: @user.id }
    end

    assert_redirected_to tree_path(assigns(:tree))
  end

  test "should show tree" do
    get :show, id: @tree
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tree
    assert_response :success
  end

  test "should update tree" do
    patch :update, id: @tree, tree: { common_name: @tree.common_name, 
      family_name: @tree.family_name, 
      scientific_name: @tree.scientific_name,
      user_id: @user.id }
    assert_redirected_to tree_path(assigns(:tree))
  end

  test "should not destroy tree with forein key references" do
    assert_no_difference('Tree.count') do
      delete :destroy, id: @tree
    end

    assert_redirected_to trees_path
  end

  test "should destroy tree with no foreign key references" do
    assert_difference('Tree.count', -1) do
      delete :destroy, id: trees(:no_references)
    end

    assert_redirected_to trees_path
  end
end
