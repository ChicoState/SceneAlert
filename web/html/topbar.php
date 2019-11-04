<?php
  require_once('inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
?>
  <div id="nav-topbar">
    
    <!-- Left Size of Navi Bar -->
    <div id="nav-main">
      <ul>
        <li><button>About</button></li>
        <li><button>Forums</button></li>
        <li><button>Contact</button></li>
        <li><button>Help</button></li>
      </ul>
    </div>
    
    <!-- Right side of navigation bar -->
    <div id="nav-user">
    
      <!-- Account / Contact Buttons -->
      <div id="nav-btns">
        <ul>
<?php
    if (isset($_SESSION['user'])) {
      echo '<li><button onclick="doLogoff();">Log Off</button></li>';
      echo '<li><button onclick="doSettings();">Settings</button></li>';
    } else {
      echo '<li><button onclick="ShowLoginBlock();">Login</button></li>';
    }
?>
        </ul>
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