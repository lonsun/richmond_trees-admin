require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @address = addresses(:one)
  end

  describe "full_address method" do
    it "gets the full address" do
      @address.full_address.must_equal "123 Happy St., Richmond, CA  94804"
    end
  end
end
