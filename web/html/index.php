<html>
  <?php require_once('inc/database.php'); ?>
  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    <link rel="stylesheet" href="inc/index.css">
    <link rel="stylesheet" href="inc/info.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    
    <!-- The Google Map Script -->
    <script type="text/javascript" src="js/googlemap.js"></script>
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
    
    <!-- Infowindow on Pin Click -->
    <div id="info-window">
      <div id="info-type">SYSTEM ADMINISTRATOR</div>
      <div id="info-title">This is just a test</div>
      <div id="info-report">
        <table>
          <tr>
            <th width="20%">Reported:</th>
            <td width="80%" id="info-rtime">4 Hours Ago</td>
          </tr>
          <tr>
            <th>Reporter:</th>
            <td id="info-rname">CHP Dispatch (Auto)</td>
          </tr>
        </table>
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
      <div id="info-help">
        <button>ISSUE</button>
        <button>REPORT</button>
      </div>
    </div>
    
    <script type="text/javascript" src="js/clock.js"></script>
  </body>
  
</html>