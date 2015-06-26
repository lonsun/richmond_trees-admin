require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:testuser1);
  end

  describe "when getting the full name" do
    it "gets the full name of user" do
      @user.get_full_name.must_equal "test user1"
    end

    it "omits leading space if first_name is not present" do
      @user.first_name = ""
      @user.get_full_name.must_equal "user1"
    end

    it "omits trailing space if last_name is not present" do
      @user.last_name = ""
      @user.get_full_name.must_equal "test"
    end

    it "returns empty string if both are empty or nil" do
      @user.first_name = nil
      @user.last_name = ""
      @user.get_full_name.must_equal ""
    end
  end
end
