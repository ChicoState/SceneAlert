<html>
  <?php require_once('inc/database.php'); ?>
  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    <link rel="stylesheet" href="inc/index.css">
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript">
      var map;
      function initMap() {
        map = new google.maps.Map(document.getElementById('gmap'), {
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