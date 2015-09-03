require 'test_helper'

class GeocoderIntegrationTests < ActionController::TestCase
  setup do
    # authenticate
    activate_authlogic
    UserSession.create(users(:testuser1))
    
    @adoption_request = adoption_requests(:one)
    @user = users(:testuser1)

    Geocoder::Lookup::Test.add_stub(
      "1 Street, New York, NY", [
        {
          'latitude'     => 40.7143528,
          'longitude'    => -74.0059731,
          'address'      => 'New York, NY, USA',
          'state'        => 'New York',
          'state_code'   => 'NY',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )
  end

  describe "geocoder gem" do
    describe "on save" do
      it "should automatically lookup the latitude and longitude if the address exists and save it" do
        a = AdoptionRequest.new( 
          {
            "house_number" => 1,
            "street_name" => "Street",
            "city" => "New York",
            "state" => "NY",
            "user_id" => 1
          }
        )

        a.latitude.must_be_nil 

        a.save

        a.latitude.must_equal 40.7143528
      end

      it "should not lookup the latitude and longitude if the address does not exist" do
        a = AdoptionRequest.new( 
          {
            "house_number" => nil,
            "street_name" => nil,
            "city" => nil,
            "state" => nil,
            "user_id" => 1
          }
        )

        a.latitude.must_be_nil 

        a.save

        a.latitude.must_be_nil
      end

      it "should not lookup the latitude and longitude if the address has not changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.room_for_tree = true
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_be_nil
      end

      it "should lookup the latitude and longitude and save it if the house number has changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.house_number = 999
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the street name has changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.street_name = "Blardy"
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the city has changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.city = "No City"
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the state has changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.state = "No State"
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the zip code has changed" do
        @adoption_request.latitude.must_be_nil 

        @adoption_request.zip_code = 99999
        @adoption_request.changed.size.must_equal 1
        @adoption_request.save

        @adoption_request.latitude.must_equal 12.345678
      end
    end

    describe "on update" do
      it "should not lookup the latitude and longitude if the address has not changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "house_number" => @adoption_request.house_number } )

        @adoption_request.latitude.must_equal nil
      end

      it "should lookup the latitude and longitude and save it if the house number has changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "house_number" => 999 } )

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the street name has changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "street_name" => "Blardy" } )

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the city has changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "city" => "No City" } )

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the state has changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "state" => "No State" } )

        @adoption_request.latitude.must_equal 12.345678
      end

      it "should lookup the latitude and longitude and save it if the zip code has changed" do
        @adoption_request.latitude.must_be_nil

        @adoption_request.update( { "zip_code" => 99999 } )

        @adoption_request.latitude.must_equal 12.345678
      end

    end
  end
end
