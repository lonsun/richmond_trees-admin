require 'test_helper'

class TreeTest < ActiveSupport::TestCase
  setup do
    @tree = trees(:one)
  end

  describe "text_for_html_select_option method" do
    it "gets the text part for the option" do
      @tree.text_for_html_select_option.must_equal "Bay Laurel"
    end

    it "should not fail if the common name is nil" do
      @tree.common_name = nil
      @tree.text_for_html_select_option.must_equal ""
    end
  end
end
