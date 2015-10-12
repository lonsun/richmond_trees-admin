$( document ).on("ready", function() {
  // base class 
  function MarkersData( jquery_source_selector ) {
    this.markers_data = [];
    this.source_selector = jquery_source_selector;
  }

  MarkersData.prototype.return_data = function() {
    return this.markers_data;
  }

  // inherets from MarkersData
  function PlantingMarkersData( jquery_source_selector ) {
    MarkersData.apply( this, arguments );

    //The first element in the array tells you the type
    this.markers_data[0] = "planting";

    var parent_markers_data = this.markers_data;

    this.gather = function() {
      $( this.source_selector ).each( function() {
        var data = $( this ).val();
        
        var data_parts = data.split( "|" ); 
        var id = parseInt( data_parts[0] );
        var lat = parseFloat( data_parts[1] );
        var lng = parseFloat(data_parts[2] );
        var tree = data_parts[3];
        var placement = data_parts[4];
        var street_address = data_parts[5];

        parent_markers_data.push(
          {
            "id": id,
            "lat": lat,
            "lng": lng,
            "tree": tree,
            "tree_placement": placement,
            "street_address": street_address
          }
        );
      });
    }
  }

  PlantingMarkersData.prototype = Object.create( MarkersData.prototype );
  PlantingMarkersData.prototype.constructor = PlantingMarkersData;
 
  // inherets from MarkersData
  function AdoptionRequestMarkersData( jquery_source_selector ) {
    MarkersData.apply( this, arguments );

    //The first element in the array tells you the type
    this.markers_data[0] = "adoption_request";

    var parent_markers_data = this.markers_data;

    this.gather = function() {
      $( this.source_selector ).each( function() {
        var data = $( this ).val();
        
        var data_parts = data.split( "|" ); 
        var id = parseInt( data_parts[0] );
        var lat = parseFloat( data_parts[1] );
        var lng = parseFloat(data_parts[2] );
        var street_address = data_parts[3];
        var received_on = data_parts[4];

        parent_markers_data.push(
          {
            "id": id,
            "lat": lat,
            "lng": lng,
            "street_address": street_address,
            "received_on": received_on
          }
        );
      });
    }
  }

  AdoptionRequestMarkersData.prototype = Object.create( MarkersData.prototype );
  AdoptionRequestMarkersData.prototype.constructor = AdoptionRequestMarkersData;

  // Rails 4 doesn't have a clean way to handle loading javasacript files only
  // for specific pages, so all different map generation calls go here for now.
  $( "#plantings-results-map-action" ).click(function( e ) {
    e.preventDefault();

    var markers_data = new PlantingMarkersData( "input[name='map-coordinates']" );
    markers_data.gather();

    MapLib.setMarkers( markers_data.return_data() );
    MapLib.send();
  })

  $( "#adoption-request-results-map-action" ).click(function( e ) {
    e.preventDefault();

    var markers_data = new AdoptionRequestMarkersData( "input[name='map-coordinates']" );
    markers_data.gather();

    MapLib.setMarkers( markers_data.return_data() );
    MapLib.send();
  })

});
