<?php
  require_once('inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
?>
  <div id="nav-topbar">
    
    <!-- Main Page Navigation -->
    <div id="nav-main">
      <ul>
        <li><button><img src="img/facebook.png" height="30px"></button></li>
        <li><button><img src="img/twitter.png" height="30px"></button></li>
        <li><button>About</button></li>
        <li><button>Forums</button></li>
        <li><button>Contact</button></li>
        <li><button>Help</button></li>
      </ul>
    </div>
    
    
    <div id="nav-user">
      <ul>
<?php
    if (isset($_SESSION['user'])) {
      echo '<li><button onclick="doLogoff();">Log Off</button></li>';
      echo '<li><button onclick="doLogoff();">Settings</button></li>';
    } else {
      echo '<li><button onclick="doLogoff();">Sign On</button></li>';
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