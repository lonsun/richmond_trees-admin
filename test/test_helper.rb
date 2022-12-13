ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
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

# monkeypatch to avoid double-initialize errors.  See https://github.com/rails/rails/issues/34790
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end
