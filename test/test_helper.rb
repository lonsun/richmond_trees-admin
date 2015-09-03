ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# authlogic
require "authlogic/test_case"

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # geocoder
  Geocoder.configure( :lookup => :test )
  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'latitude'     => 12.345678,
        'longitude'    => 98.765432,
        'address'      => 'Richmond, CA, USA',
        'state'        => 'California',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US'
      }
    ]
  )
end
