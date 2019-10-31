<html>
  <?php require_once('inc/database.php'); ?>
  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    <link rel="stylesheet" href="inc/index.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript">
    
      var marks = [];
      var gMap;
      
      function HasMarker(latt, lngt) {
        for (var i = 0, l = marks.length; i < l; i++) {
          if (marks[i][0] === latt && marks[i][1] === lngt) {
            return true;
          }
        }
        return false;
      }
      
      /*
        Result: id, title, details, created, type, upvote, downvote
      */
      function CreateMarker(latt, lngt, result) {
        console.log(
          'LAT: ' + latt + '(' + typeof(latt) +
          ')/ LNG: ' + lngt + '('+ typeof(lngt) + ')'
        );
        if (!HasMarker(latt, lngt)) {
          
          console.log('Adding: ' + result[1]);
          
          var latLong = new google.maps.LatLng(latt, lngt);
          
          var marker = new google.maps.Marker({
            position: latLong,
            map: gMap,
            title: result[1],
            icon: 'img/pins/' + result[4] + 's.png',
            size: new google.maps.Size(26, 32),
            visible: true
          });
        
          marks.push([latt, lngt]);
        
        } else {
          console.log('NOT Adding: Marker Exists.');
        }
      }
      
      
      function LoadMarkers() {
        $.ajax({
          url: "php/incidents.php",
          success: function(result) {
            var jsn = JSON.parse(result);
            for (var i = 0; i < jsn.length; i++) {
              CreateMarker(Number(jsn[i][2]), Number(jsn[i][1]), [
                jsn[i][0], jsn[i][3], jsn[i][5], jsn[i][4], jsn[i][6], jsn[i][7], jsn[i][8]
              ]);
            }
          },
          error: function(result) {
            console.log("Failed. ["+result.responseText+"]");
          }
        });
      }
      
      
      function initMap() {
        gMap = new google.maps.Map(document.getElementById('gmap'), {
          center: {lat: 37.0902, lng: -95.7129},
          zoom: 5,
          zoomControl: true,
          mapTypeControl: false,
          mapTypeId: 'terrain',
          scaleControl: true,
          streetViewControl: false,
          rotateControl: true,
          fullscreenControl: false
        });
        LoadMarkers();
      }
      
      
    </script>
    <script
      async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBH1jW5Aqd8lHL7RoiiKx9COdioIRdGs8Q&callback=initMap"
      type="text/javascript">
    </script>
    
  </head>
  
  
  <body>
    
    <!-- The Map -->
    <div id="gmap"></div>
    
    <!-- Top Bar: Home/About/Account/FAQ/etc -->
    <div id="nav-topbar">
      <div id="display-dtime">
        <div id="display-date"></div>
        <div id="display-time"></div>
      </div>
    </div>
    
    <!-- Side Bar: Operational Stuff -->
    <div id="nav-sidebar">
    
      <!-- Top half: Informational/Call View -->
      <div id="nav-info">
        
      </div>
      
      <!-- Bottom Half: Functional Stuff (New/Edit) -->
      <div id="nav-func">
        
      </div>
      
    </div>
    
    <!-- Right Side: Titlebar & Google Map -->
    <div id="display-main">
    </div>
    
    <script type="text/javascript" src="js/clock.js"></script>
  </body>
  
</html>