// Utility for building a relative path/url for tree icons to use on a map.
var TreeIconPath = (function() {
  var tip = {};
  var asset_path = '/assets/';
  var file_part_prefix = 'tree_icon_';
  var file_part_suffix = '16x16.png';
  var underscore = '_';
  var max_trees = 10;

  tip.build = function( number_of_trees ) {
    if( number_of_trees < max_trees && number_of_trees > 0 ) {
      return asset_path + file_part_prefix + number_of_trees + underscore + file_part_suffix;
    }
    else {
      return asset_path + file_part_prefix + file_part_suffix;
    }
  }

  return tip;
})();

// Utility for grouping a list of map markers and adding a count for each unique marker.
var MapMarkers = (function() {
  var mm = {}

  mm.group = function( markers ) {
    var found;
    var grouped_markers = [];

    markers.forEach(function( m ) {
      found = grouped_markers.some(function ( gm ) {
        if( gm.lat == m.lat && gm.lng == m.lng ) {
          gm.count++;
          return true;
        } 
      });

      if( ! found ) {
        grouped_markers.push(
          {
            lat: m.lat,
            lng: m.lng,
            count: 1
          }
        );
      }
    });

    return grouped_markers;
  }

  return mm;
})();

function GoogleMap( $, target_element, options ) { 
  var options = options || {};

  this.markers = [];
  this.target_element = document.getElementById( target_element );

  this.options = $.extend( {}, this.default_options, options );

  this.map = new google.maps.Map( this.target_element, this.options );

  // markers parameter should be an ariray of objects.  Each
  // object should include at least "lat" and "lng" properties.
  this.setMarkers = function( markers ) {
    this.markers = markers;
  }
}

GoogleMap.prototype.default_options = { 
  center: { lat: 37.935759, lng: -122.347532 },
  zoom: 14
}

GoogleMap.prototype.createMarkersOnMap = function() {
  var m, gm;
  var markers = MapMarkers.group( this.markers );

  for( var i = 0; i < markers.length; i++ ) {
    m = markers[i];

    gm = new google.maps.Marker({
      position: { lat: m.lat, lng: m.lng },
      map: this.map,
      icon: TreeIconPath.build( m.count )
    });
  }
}
