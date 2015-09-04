$( document ).on("ready", function() {
  // gather map data from appropriate page elements
  function getMapMarkers() {
    var map_data = [];

    $( "input[name='map-coordinates']" ).each( function() {
      var data = $( this ).val();
      
      var data_parts = data.split( "|" ); 
      var id = parseInt( data_parts[0] );
      var lat = parseFloat( data_parts[1] );
      var lng = parseFloat(data_parts[2] );

      map_data.push(
        {
          "id": id,
          "lat": lat,
          "lng": lng
        }
      );
    });

    return map_data;
  }

 
  $( "#map-results-action" ).click(function( e ) {
    e.preventDefault();
    
    MapLib.setMarkers( getMapMarkers() );
    MapLib.send();
  })
});
