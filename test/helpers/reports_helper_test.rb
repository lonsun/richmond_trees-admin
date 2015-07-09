require 'test_helper'

class ReportsHelperTest < ActionView::TestCase
  include ReportsHelper

  describe "wildcard_if_empty method tests" do
    it "wraps the value in wildcard characters" do
      wildcard_if_empty( "" ).must_equal "%"
      wildcard_if_empty( "abc " ).must_equal "abc "
    end

    it "should treat nil as empty" do
      wildcard_if_empty( nil ).must_equal "%"
    end
  end

  describe "remove_empty_values method tests" do
    it "removes empty strings from array" do
      a = [ "", "a", "b" ]
      remove_empty_values( a ).must_equal [ "a", "b" ]
    end

    it "does not affect arrays that don't have empty strings" do
      a = [ "1", "!@", 0 ]
      remove_empty_values( a ).must_equal [ "1", "!@", 0 ]

      b = []
      remove_empty_values( b ).must_equal []           
    end

    it "raises ArgumentError when the parameter is not an array" do
      proc { remove_empty_values( nil ) }.must_raise ArgumentError
    end
  end
end
