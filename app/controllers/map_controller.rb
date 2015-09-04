class MapController < ApplicationController

  # Send an array of JSON objects with at least "id", "lat", and "lng" data.
  def index
    p = map_params  

    @markers = p["markers"].nil? ? [] : JSON.parse( p["markers"] )
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.permit( :markers );
    end
end
