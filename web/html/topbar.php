<?php
  require_once('inc/database.php');
  session_start();
?>
  <div id="nav-topbar">
    
    <!-- Main Page Navigation -->
    <div id="nav-main">
      <ul>
        <li>About</li>
        <li>Forums</li>
        <li>Contact</li>
        <li>Help</li>
      </ul>
    </div>
    
    
    <div id="nav-user">
<?php
    if (isset($_SESSION['user'])) {
      echo "Logged in as <strong>" . $_SESSION['email'] . "</strong><br>";
      echo '<button onclick="doLogoff();">Log Off</button>';
    }
?>
    </div>
      <!-- Time & Date -->
      <div id="display-dtime">
        <div id="display-date"></div>
        <div id="display-time"></div>
      </div>
      
    </div>
    
  </div>
  <script type="text/javascript" src="js/clock.js"></script>
<?php
?>