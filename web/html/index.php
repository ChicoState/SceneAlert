<html>
  <?php
  
    require_once('inc/database.php');
    
  ?>
  <head>
    <title>SceneAlert - Real Time Incident Reporting</title>
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" href="inc/index.css">
    <link rel="stylesheet" href="inc/info.css">
    <link rel="stylesheet" href="inc/topbar.css">
    
    <!-- Javascript SDK -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    
    <!-- The Google Map Script 
    <script type="text/javascript" src="js/googlemap.js"></script>
    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBH1jW5Aqd8lHL7RoiiKx9COdioIRdGs8Q&callback=initMap"
      type="text/javascript">
    </script> -->
    
    <!-- Loose Javascript -->
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
      
      function HideLogin() {
        $("#acct-details").fadeOut(200);
      }

    </script>
    
  </head>
  
  
  <body>
    
    <!-- The Map -->
    <div id="gmap"></div>
    
    <!-- Login Block -->
    <div id="acct-details">
    
      <h3>Log in to Scene-Alert!</h3>
      
      <p><i><u>
      <font color="#04f">
      <a onclick="HideLogin()">No thanks, I want to view as a guest</a>
      </font>
      </u></i></p>
      
      <input type="text" id="uname" name="uname" placeholder="Username"/>
      <br/>
      <input type="password" id="passwd" name="passwd" plaheolder="Password"/>
      <br/>
      <input type="submit" value="Submit"/>
      
    </div>
    
    <!-- Top Bar: Home/About/Account/FAQ/etc -->
    <?php include('topbar.php'); ?>
    <?php include('legend.php'); ?>
    
    
    <!-- Controls -->
    <div id="call-control">
    
      <h3>Control Panel</h3>
      
      <!-- Controls to Search / View -->
      <div id="call-search">
        <table>
          <tr>
            <th colspan="2">Search for Address</th>
          </tr>
          <tr>
            <td width="70%">
              <input type="text" id="sr-addr" name="sr-addr" placeholder="123 Easy Street">
            </td>
            <td width="30%">
              <button onclick="SearchAddress()">Search</button>
            </td>
          </th>
        </table>
      </div>
      
      <!-- Controls to create a call or edit existing -->
      <div id="call-create">
        <h3>New Incident</h3>
        <p><button onclick="NewCallHelp()">Help</button>
        <table>
          <tr>
            <td>Address</td>
            <td><input type="text" id="new-stnumber" name="new-stnumber" placeholder="123"/></td>
            <td><input type="text" id="new-stname" name="new-stname" placeholder="Easy Street"/></td>
          </tr>
          <tr>
            <td><input type="number" id="new-zip" name="new-zip" placeholder="90210 (opt)"></td>
            <td><input type="text" id="new-city" name="new-city" placeholder="City Name (opt)"></td>
            <td><input type="text" id="new-state" name="new-state" placeholder="CA" maxlength="2"></td>
          </tr>
          <tr>
            <td>Situation</td>
            <td colspan="2">
              <select>
                <option value="1">Police Activity</option>
                <option value="2">Fire / Rescue</option>
                <option value="3">Medical Emergency</option>
                <option value="4">Multi-Agency</option>
                <option value="5">Military Operation</option>
              </select>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <input type="text" id="new-details" name="new-details" placeholder="Brief Title of Event"/>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <textarea></textarea>
            </td>
          </tr>
          <tr>
            <td colspan="3"><button onclick="NewCallCreate()">Submit</button>
          </tr>
        </table>
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
  </body>
  
</html>