var MapLib = {
  "markers": [],

  // markers_data parameter should contain an array of objects with at least:
  // id: the planting id
  // lat: the latitude coordinate
  // lng: the longitude coordinate
  "setMarkers": function( markers_data ) {
    this.markers = markers_data
  },

  "send": function() {
    var map_form = $("<form>", 
      {
        "action": "/map",
        "method": "post",
        "target": "_blank"
      }
    );

    var csrf_input = $("<input>", 
      {
        "name": "authenticity_token",
        "value": $( 'meta[name="csrf-token"]' ).attr( "content" ),
        "type": "hidden"
      }
    );

    var markers_input = $("<input>", 
      {
        "name": "markers",
        "value": JSON.stringify( this.markers ),
        "type": "hidden"
      }
    );

    map_form.append( csrf_input );
    map_form.append( markers_input );
    map_form.submit();
  }
};
