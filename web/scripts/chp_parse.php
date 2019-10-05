<?php

  require_once('database.php');

  echo "Preparing to parse [chp_incidents.xml].\n";

  // Variable init
  $read_new = "files/chp_incidents.xml";
  $read_old = "files/chp_incidents_old.xml";
  
  /*   Organization:
    $newIncidents = {
       [0] = (Log ID)
       [1] = (LogType/The type of Call),
       [2] = (Latitude),
       [3] = (Longitude)
    }
  */
  
  // if $newIncidents[LogID] = $oldIncidents[LogID], do NOT insert into MySQL
  // DEBUG - Later: If they match, check for new info and update MySQL. Otherwise ignore
  $newIncidents = array();

  // Read latest CHP XML. If not found, terminate
  $newFile = fopen($read_new, "r") or die("Failed to read chp_incidents.xml.\n");
  $oldFile = fopen($read_new, "r");
  
  // Read through new file until we get to Chico Dispatch.
  $findChico = 'Dispatch ID = "CHCC"';
  $isChico = false;
  
  while(!$isChico) {
    if (feof($newFile)) { break; }
    $line = fgets($newFile);
    // If we found the Chico Dispatch Center, stop
    if (strpos($line, $findChico)) {
      $isChico = true;
      break;
    }
  }
  
  if ($isChico) {
    // Continue to loop as long as we're still in the Chico Dispatch Center
    echo "Located CHP Incidents for Chico Dispatch area.\n";
    $findLog = 'Log ID';
    while(!feof($newFile) and $isChico) {
      $line = fgets($newFile);
      // If we found a Log ID, pay closer attention
      if (strpos($line, $findLog)) {
        
        // Capture the Log ID [0]
        preg_match_all('/"([^"]+)"/', $line, $retString);
        $log = str_replace('"', '', $retString[0][0]);
        
        // 2 lines after is the Incident Type
        fgets($newFile);
        $line = fgets($newFile);
        preg_match_all('/"([^"]+)"/', $line, $retString);
        $type = str_replace('"', '', $retString[0][0]);
        
        // Next line is the Location [2]
        $line = fgets($newFile);
        preg_match_all('/"([^"]+)"/', $line, $retString);
        $loc = str_replace('"', '', $retString[0][0]);
        
        // 4 lines later then that is the lat and long [3]
        fgets($newFile); fgets($newFile); fgets($newFile);
        $line = fgets($newFile);
        preg_match_all('/"([^"]+)"/', $line, $retString);
        $latlong = str_replace('"', '', $retString[0][0]);
        
        $newIncidents[] = array($log, $type, $loc, $latlong);
      }
      // Stop if we find the ending dispatch center tag
      if (strstr($line, '</Dispatch>')) {
        $isChico = false;
        break;
      } else {echo "Continue\n";}
    }
    echo "~~~ DEBUG ~~~\n";
    foreach($newIncidents as $key => $value) {
      echo $key.' -> 0:'.$value[0].' 1:'.$value[1].' 2:'.$value[2].' 3:'.$value[3];
      echo "\n";
      
      $qCheck = "SELECT COUNT(*) FROM incidents WHERE chp = :log";
      $qChk = $db->prepare($qCheck);
      $qChk->bindParam(':log', $value[0]);
      $qChk->execute();
      
      $chpLog = $qChk->fetchColumn();
      if ($chpLog < 1) {
        echo "New CHP Incident Detected (CHP ".$value[0].")\n";
        
        // Check if Longitude / Latitude already exists
        $colon = strpos($value[3], ':');
        $lat = substr($value[3], 0, $colon);
        // Longitude in California is West, so it needs to be negative
        echo "Converting LONGLAT integers to valid Coordinates of Degrees...\n";
        $long = "-" . substr($value[3], $colon + 1, strlen($value[3]));
        $latitude  = substr_replace($lat,  '.', 2, 0);
        $longitude = substr_replace($long, '.', 4, 0);
          
        echo 'LAT('.$latitude.')'."\n";
        echo 'LONG('.$longitude.')'."\n";
        $qGrid = "SELECT COUNT(*) FROM locations WHERE longitude = :long AND latitude = :lat";
        $gCheck = $db->prepare($qGrid);
        $gCheck->bindParam(':lat', $latitude);
        $gCheck->bindParam(':long', $longitude);
        $gCheck->execute();
        
        $gridExists = $gCheck->fetchColumn();
        if ($gridExists < 1) {
          echo "idLocation for (".$longitate.":".$latitude.") not found.\n";
          echo "Generating a new idLocation for coordinates.\n";
          
          // DEBUG - Must be changed later to a stored procedure that
          // takes into account city, state, county, etc.
          $qLoc = "SELECT AddCHPLoc(:long, :lat, :name)";
          $locInsert = $db->prepare($qLoc);
          $locInsert->bindParam(':long', $longitude);
          $locInsert->bindParam(':lat', $latitude);
          $locInsert->bindParam(':name', $value[2]);
          
          if ($locInsert->execute()) {
            $idLocn = $locInsert->fetchColumn();
            echo "Successfully added idLocation #".$idLocn."\n";
            echo "Adding CHP Incident #".$value[0]." to Database...\n";
            
            $qInc = "SELECT AddCHPInc(:loc, :deets, :titlename, :oride, :num)";
            $newInc = $db->prepare($qInc);
            $newInc->bindParam(':loc', $idLocn);
            $newInc->bindValue(':deets', 'Reported by CA Highway Patrol');
            $newInc->bindParam(':titlename', $value[1]);
            $newInc->bindValue(':oride', 1);
            $newInc->bindParam(':num', $value[0]);
            $newInc->execute();

            echo "Created SceneAlert Incident #".$newInc->fetchColumn().".\n";
            
          } else {
            echo "Failed to add coordinates into MySQL.\n";
            echo "The incident failed to be created due to errors.\n";
          }          
        } else {
          echo "Grid coordinates exist. Using existing SQL data.\n";
        }
        
      } else {
        echo "CHP Incident ".$value[0]." already exists in the MySQL Database!\n";
      }
    }
    echo "Finished parsing CHP Incidents.\nTerminating.\n\n";
  }
  else {
    echo "No incidents currently in the Chico Dispatch area.\nNothing to do.\nTerminating.\n\n";
  }
?>
