require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  setup do
    @note = notes(:one)
  end

  describe "created_by_name method" do
    it "returns the full name of the user that created the note" do
      @note.created_by_name.must_equal "test user1"
    end
  end
end
