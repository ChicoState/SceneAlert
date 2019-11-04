<?php
  require_once('inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
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
    </div>
<?php
    if (isset($_SESSION['user'])) {
      echo '<button onclick="doLogoff();">Log Off</button>';
    }
?>
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