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

  function format_tree_description( marker ) {
    var tree_description;

    if( marker.hasOwnProperty( "tree" ) ) {
      var placement = marker.tree_placement || "";
      tree_description = marker.tree + "(" + marker.tree_placement + ")";
    } 
    else {
      tree_description = "";
    }

    return tree_description;
  }

  mm.group = function( markers ) {
    var found, tree_description;
    var grouped_markers = [];

    markers.forEach(function( m ) {
      tree_description = format_tree_description( m );

      found = grouped_markers.some(function ( gm ) {
        if( gm.lat == m.lat && gm.lng == m.lng ) {
          gm.count++;
          gm.trees.push( tree_description );
          return true;
        } 
      });

      if( ! found ) {
        grouped_markers.push(
          {
            lat: m.lat,
            lng: m.lng,
            count: 1,
            trees: [ tree_description ],
            street_address: m.street_address
          }
        );
      }
    });

    return grouped_markers;
  }

  return mm;
})();

// Utility for formatting the info for each marker's info window
var InfoWindow = (function() {
  var iw = {}

  iw.format = function( street_address, trees_array ) {
    var content = street_address + ":<br /><ul>";

    trees_array.forEach(function( item ) {
      content += "<li>" + item;
    });

    content += "</ul>";

    return content;
  }

  return iw;
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
  };
}

GoogleMap.prototype.default_options = { 
  center: { lat: 37.935759, lng: -122.347532 },
  zoom: 14
}

GoogleMap.prototype.createMarkersOnMap = function() {
  var markers = MapMarkers.group( this.markers );

  for( var i = 0; i < markers.length; i++ ) {
    var m = markers[i];

    var content = InfoWindow.format( m.street_address, m.trees );

    var marker_params = {
      position: { lat: m.lat, lng: m.lng },
      map: this.map,
      icon: TreeIconPath.build( m.count )
    }
    
    var gm = new google.maps.Marker( marker_params );
    
    (function( gm, content ) {
      var iw = new google.maps.InfoWindow( {} );
      
      gm.addListener( 'click', function() {
        iw.setContent( content );
        iw.open( gm.getMap(), gm );
      });
    })( gm, content );
  }
}
