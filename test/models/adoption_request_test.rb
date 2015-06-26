require 'test_helper'

class AdoptionRequestTest < ActiveSupport::TestCase
  setup do
    @adoption_request = adoption_requests(:one)
    @adoption_request.person = people(:one)
    @adoption_request.address = addresses(:one)
  end

  describe "text_for_html_select_option method" do
    it "gets the text part for the option" do
      @adoption_request.text_for_html_select_option.must_equal "Bob Jones | 123 Happy St., Richmond, CA  94804"
    end

    it "should not fail if person is nil" do
      @adoption_request.person = nil
      @adoption_request.text_for_html_select_option.must_equal " | 123 Happy St., Richmond, CA  94804"
    end

    it "should not fail if address is nil" do
      @adoption_request.address = nil
      @adoption_request.text_for_html_select_option.must_equal "Bob Jones | "
    end
    
    it "should not fail on all nil values" do
      @adoption_request.person = nil
      @adoption_request.address = nil
      @adoption_request.text_for_html_select_option.must_equal " | "
    end
  end
end
