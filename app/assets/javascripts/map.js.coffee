# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@initMap = ->
  gmap = new GoogleMap( jQuery, 'map' )
  gmap.setMarkers markers
  gmap.createMarkersOnMap()
  return
