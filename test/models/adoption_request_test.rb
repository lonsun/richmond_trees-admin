require 'test_helper'

class AdoptionRequestTest < ActiveSupport::TestCase
  setup do
    @adoption_request = adoption_requests(:one)
    @empty_adoption_request = adoption_requests(:empty)
  end

  describe "text_for_html_select_option method" do
    it "gets the text part for the option" do
      @adoption_request.text_for_html_select_option.must_equal "Bob Jones | 123 Happy St., Richmond, CA, 94804"
    end
    
    it "should not fail on all nil values" do
      @empty_adoption_request.text_for_html_select_option.must_equal " | "
    end
  end

  describe "#street_address" do
    it "gets the full street address" do
      @adoption_request.street_address.must_equal "123 Happy St."
    end
  end

  describe "full_address method" do
    it "gets the full address" do
      @adoption_request.full_address.must_equal "123 Happy St., Richmond, CA, 94804"
    end
  end

  describe "owner_full_name method" do
    it "gets the full name of adoption_request" do
      @adoption_request.owner_full_name.must_equal "Bob Jones"
    end

    it "omits leading space if first_name is not present" do
      @adoption_request.owner_first_name = ""
      @adoption_request.owner_full_name.must_equal "Jones"
    end

    it "omits trailing space if last_name is not present" do
      @adoption_request.owner_last_name = ""
      @adoption_request.owner_full_name.must_equal "Bob"
    end

    it "returns empty string if both are empty or nil" do
      @adoption_request.owner_first_name = nil
      @adoption_request.owner_last_name = ""
      @adoption_request.owner_full_name.must_equal ""
    end
  end
end
