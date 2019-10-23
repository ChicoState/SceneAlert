<html>

  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    <link rel="stylesheet" href="inc/index.css">
    
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript">
    
    // The latitude and longitude of your business / place
    
    var position = [39.728313, -121.838812];
    var blips    = [];
    
    function initMap() {
      
      // The location of position
      var centre = {lat: position[0], lng: position[1]};
      
      // The map, centered at position
      var map = new google.maps.Map(
          document.getElementById('gmap'), {zoom: 16, center: centre}
      );
          
      /*
      // The marker, positioned at Uluru
      var marker = new google.maps.Marker({position: uluru, map: map});
      
      // Add to marker tracker
      blips.push([position[0], position[1]]);
      */
      var mapOptions = {
        center: centre, zoom: 10,
        streetViewControl: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
    }
    
    function IsLocationMarked(posn) {
      for (var i = 0, l = blips.length; i < l; i++) {
        if (blips[i][0] == posn[0] && blips[i][1] == posn[1]) {return true;}
      }
      return false;
    }
    
    
    
    </script>
    <script
      async defer
      src="https://maps.googleapis.com/maps/api/js?key=<?php
        include('api/maps_dynamic.php');
      ?>&callback=initMap"
      type="text/javascript">
    </script>
  </head>
  
  
  <body>
  
  <div id="gmap"></div>
  
  </body>
  
</html>