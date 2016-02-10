require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))

    @note = notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create note" do
    assert_difference('Note.count') do
      post :create, note: { planting_id: @note.planting_id,
        user_id: @note.user_id,
        note: @note.note }
    end

    assert_response :redirect
  end

  test "should show note" do
    get :show, id: @note
    assert_response :success
  end

  # test "should get edit" do
  #   get :edit, id: @note
  #   assert_response :success
  # end

  # test "should update note" do
  #   patch :update, id: @note, note: { planting_id: @note.planting_id,
  #       user_id: @note.user_id,
  #       note: @note.note }
  #   assert_response :redirect
  # end

  describe "when deleting an adoption_request" do
    it "should be deleted when passed a \"hard_delete\" parameter with the value of \"yes\"" do
      assert_difference('Note.count', -1) do
        delete :destroy, { id: @note, "hard_delete" => "yes" }
      end

      assert_redirected_to controller: "plantings", action: "show",
        id: @note.planting_id
    end

    it "should be marked as ignored by default" do
      assert_difference('Note.count', 0) do
        delete :destroy, id: @note
      end

      ar = Note.find(@note.id)
      assert_equal true, ar.ignore
      assert_redirected_to controller: "plantings", action: "show",
        id: @note.planting_id
    end
  end

  describe "when attempting to access an ignored record" do
    it "should be treated as if it doesn't exist" do
      ignored = notes( :ignored )
      assert_raises( ActiveRecord::RecordNotFound ) { get :show, id: ignored }
    end
  end

end
