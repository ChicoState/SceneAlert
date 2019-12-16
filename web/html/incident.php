<html>
  <?php
    include('inc/database.php');
  ?>
  <head>
    <title>SceneAlert - Be Aware, Stay Alert</title>
    
    <!-- AdSense -->
    <script data-ad-client="ca-pub-7458215793864857" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="inc/index.css">
    <link rel="stylesheet" href="inc/info.css">
    <link rel="stylesheet" href="inc/topbar.css">
    <link rel="stylesheet" href="inc/footer.css">
    
    <!-- Javascript SDK -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    
    <!-- The Google Map Script -->
    <script type="text/javascript" src="js/googlemap.js"></script>
     
     
    <!-- Loose Javascript -->
    <script type="text/javascript" src="js/login.js"></script>
    <script type="text/javascript" src="js/control.js"></script>
    <script type="text/javascript">
      
      var showLegend = true;
      
      function LocationByAddress(addr, cInfo, idMyself) {
        
        console.log('GeoCoding ' + addr + '...');
        var geocoder = new google.maps.Geocoder();
        
        geocoder.geocode({ 'address' : addr}, function(results, status) {
          
          console.log(results[0]);
          
          // Get basic longitude/latitude response first
          var c = results[0].geometry.location;
          var latitude  = ( c.lat() ).toFixed(8);
          var longitude = ( c.lng() ).toFixed(8);
          
          // Try to obtain the rest of the stuff we would like to have
          var addrResponse = results[0].address_components;
          var addrInfo = {}; 
          $.each(addrResponse, function(k,v1) {
            $.each(v1.types, function(k2, v2){
              addrInfo[v2] = v1.long_name
            });
          });
          
          $.each(addrInfo, function(k, v) {
            console.log(k + ": " + v);
          });
          
          var titty = addrInfo.street_number + ' ' + addrInfo.route
          $.ajax({
            url: 'php/new_location.php',
            type: 'POST',
            data: {
              num:    addrInfo.street_number,
              str:    addrInfo.route,
              title:  titty,
              city:   addrInfo.locality,
              county: addrInfo.administrative_area_level_2,
              state:  addrInfo.administrative_area_level_1,
              nation: addrInfo.country,
              postal: addrInfo.postal_code,
              longt:  longitude,
              latt:   latitude
            },
            success: function(result) {
              var answer = jQuery.parseJSON(result);
              if (answer[0] == 1) {
                console.log('idLoc: ' + answer[1]);
                CreateFinalReport(answer[1], cInfo, idMyself);
              } else {
                console.log('Failure: ' + answer[1]);
              }
            },
            error: function(result) {
              
            }
          });
          
        });
      }
  
      function ToggleLegend() {
        showLegend = !showLegend;
        if (showLegend) {
          $("#legend").show();
          $("#legshow").hide();
        } else {
          $("#legend").hide();
          $("#legshow").show();
        }
      };
      
    </script>
  </head>
  
  
  <body>
    
    <!-- The Map -->
    <div id="gmap"></div>
    
    <!-- Login Block -->
    <div id="acct-details" style="display: none;">
    
      <h3>Log in to Scene-Alert!</h3>
      
      <p><i><u>
      <font color="#aff">
      <a onclick="HideLogin()">No thanks, I want to view as a guest</a>
      </font>
      </u></i></p>
      
      <form method="post" id="loginform">
        <input type="text" id="uname" name="uname" placeholder="Username"/>
        <br/>
        <input type="password" id="passwd" name="passwd" placeholder="Password"/>
        <br/>
        <input type="button" id="btn-submit" value="Submit" name="submit" onclick="SubmitFormData();"/>
        <div id="login-msg"></div>
      </form>
        
      <strong>We are not accepting new user registration during development.</strong>
      
    </div>
<?php
    if (!isset($_SESSION['user'])) {
      echo "<script>ShowLoginBlock();</script>";
    } else {
      echo "<script>LoadCallControl();</script>";
    }
?>
    
    <!-- Top Bar: Home/About/Account/FAQ/etc -->
    <div id="topdiv"><?php include('topbar.php'); ?></div>
    <div id="legdiv"><?php include('legend.php'); ?></div>
    
    
    <!-- Controls -->
    <div id="calldiv">
      <?php if (isset($_SESSION['user'])) {
        echo "<script>console.log('loading controller');</script>";
        include('controller.php');
      } ?>
    </div>
    
    <!-- Infowindow on Pin Click -->
    <div id="info-window" style="display: none;">
      <div id="info-details">
        <div id="info-title"></div>
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
      <div id="info-closure">
        <table>
          <tr>
            <td colspan="2"><textarea id="info-newnote"></textarea></td>
          </tr>
          <tr>
            <td><button id="info-closer" onclick="CloseReport()">Close Report</button></td>
            <td><button id="info-update" onclick="UpdateReport()" disabled>Submit Update</button></td>
          </tr>
        </table>
      </div>
      <div id="info-votes">
        <div id="info-vup">
          <img src="img/vote-up.png" width="32px" height="32px"/>
        </div>
        <div id="info-vcount">0</div>
        <div id="info-vdn">
          <img src="img/vote-down.png" width="32px" height="32px"/>
        </div>
      </div>
    </div>
    
    <?php include ('footer.php'); ?>
    
    <!-- Load the Google Map -->
    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBH1jW5Aqd8lHL7RoiiKx9COdioIRdGs8Q&callback=initMap"
      type="text/javascript">
    </script> 
    
    <div id="alpha"><div class="corner-ribbon">DEV VERSION</div></div>
    
  </body>
  <?php $db = null; ?>
</html>