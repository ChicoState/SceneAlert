<html>
  <?php
  
    require_once('inc/database.php');
    
  ?>
  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    <link rel="stylesheet" href="inc/index.css">
    <link rel="stylesheet" href="inc/info.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script type="text/javascript">
      var showLegend = true;
      function ToggleLegend() {
        showLegend = !showLegend
        if (showLegend) {
          $("#legend").show();
          $("#legshow").hide();
        } else {
          $("#legend").hide();
          $("#legshow").show();
        }
      }
    </script>
    <!-- The Google Map Script
    <script type="text/javascript" src="js/googlemap.js"></script>
    <script
      async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBH1jW5Aqd8lHL7RoiiKx9COdioIRdGs8Q&callback=initMap"
      type="text/javascript">
    </script>
    -->
  </head>
  
  
  <body>
    
    <!-- The Map -->
    <div id="gmap"></div>
    
    <?php include('legend.php'); ?>
    
    <!-- Top Bar: Home/About/Account/FAQ/etc -->
    <div id="nav-topbar">
      <div id="display-dtime">
        <div id="display-date"></div>
        <div id="display-time"></div>
      </div>
    </div>
    
    <!-- Infowindow on Pin Click -->
    <div id="info-window" style="display: none;">
      <div id="info-details">
        <div id="info-title">THIS IS JUST A TEST</div>
        <div id="info-report">
          Created By
          <span id="info-creator"></span> about 
          <span id="info-since"></span>
        </div>
        <div id="info-more">
          <button class="btn-more"><img src="img/info/view.png" width="32px" height="32px"/></button>
          <button class="btn-more"><img src="img/info/msg.png" width="32px" height="32px"/></button>
          <button class="btn-more"><img src="img/info/alert.png" width="32px" height="32px"/></button>
        </div>
      </div>
      <div id="info-body">
        <ul>
        
        </ul>
      </div>
      <div id="info-votes">
        <div id="info-vup">
          <img src="img/vote-up.png" width="32px" height="32px"/>
        </div>
        <div id="info-vcount">18</div>
        <div id="info-vdn">
          <img src="img/vote-down.png" width="32px" height="32px"/>
        </div>
      </div>
    </div>
    
    <script type="text/javascript" src="js/clock.js"></script>
  </body>
  
</html>