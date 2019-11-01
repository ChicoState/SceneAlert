  
  <?php

  require_once('database.php');
  
  
  /* GetIncidentTitle()
    * Uses the first part of the CHP incident name to write a proper title
    * param val The unmodified title of the CHP Incident
    * returns String; "CHP Incident" if not found
    */
  function GetIncidentTitle($val) {
    
    if (!$val) {return "CHP Incident";echo "\n// DEBUG ~ No value supplied.\n";}
    
    $titles = array(
      "1125" => "Traffic Hazard",
      "1125A" => "Animal Hazard",
      "1144" => "Fatal Incident",
      "1166" => "Defective Signal",
      "1179" => "Crash - EMS Enroute",
      "1180" => "Crash / Major Injury",
      "1181" => "Crash with Injuries",
      "1182" => "Crash without Injury",
      "1183" => "Crash - Unknown Injuries",
      "1184" => "Officer Controlling Traffic",
      "20001" => "Hit and Run - Injury",
      "20002" => "Hit and Run - No Injury",
      "23114" => "Objects Loose from Vehicle",
      "ANIMAL" => "Animal Hazard",
      "CFIRE" => "Vehicle Fire",
      "CORD" => "County Roads",
      "CZP" => "Construction",
      "DOT" => "CalTrans Requested",
      "ESCORT" => "Traffic Escort",
      "FIRE" => "Fire Affecting Traffic",
      "MZP" => "Construction",
      "TADV" => "Traffic Advisory to Media",
      "WW" => "Wrong Way Vehicle"
    );
    
    echo "\n\n// DEBUG ~ Received ".$val."\n\n";
    $temp = explode('-', $val)[0];
    if ($temp) {return ($titles[$temp] ? $titles[$temp] : "CHP Incident");
      echo ($titles[$temp] ? $titles[$temp] : "\n// DEBUG ~ No Title found\n");
    }
    echo "\n\n// DEBUG ~ Final Return.\n\n";
    return "CHP Incident";
  }

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
      }
    }
    echo "~~~ DEBUG ~~~\n";
    foreach($newIncidents as $key => $value) {
      echo $key.' -> 0:'.$value[0].' 1:'.$value[1].' 2:'.$value[2].' 3:'.$value[3];
      echo "\n";
      
      $qCheck = "SELECT COUNT(*) FROM incidents WHERE chp = :log";
      $qChk = $db->prepare($qCheck);
      $qChk->bindParam(':log', $value[0]);
      $qChk->execute();

      // THIS IS A BANDAID!!! My computer was dying
      $aCheck = "UPDATE incidents SET active = 1 WHERE chp = :log";
      $aChk = $db->prepare($aCheck);
      $aChk->bindparam(':log', $value[0]);
      $aChk->execute();
      /////////////////////////////

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
        $qGrid = "SELECT COUNT(*) AS count,idLocation AS id FROM locations WHERE longitude = :long AND latitude = :lat";
        $gCheck = $db->prepare($qGrid);
        $gCheck->bindParam(':lat', $latitude);
        $gCheck->bindParam(':long', $longitude);
        $gCheck->execute();
        
        $fetcher = $gCheck->fetch(PDO::FETCH_ASSOC);
        $locExist = $fetcher['count'];
        $idLocn = $fetcher['id'];
        echo "// DEBUG -> locExist:".$locExist." idLocn:".$idLocn."\n";
        if ($locExist < 1) {
          echo "idLocation for (".$longitude.":".$latitude.") not found.\n";
          echo "// DEBUG -> (".$value[2].")\n";
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
          } else {
            echo "Failed to add coordinates into MySQL.\n";
            echo "The incident failed to be created due to errors.\n";
          }
        } else {
          echo "Grid coordinates exist. Using existing SQL data.\n";
        }
        if ($idLocn) {
          echo "Adding CHP Incident to SceneAlert Database...\n";
          echo "DEBUG ~ idLocn:".$idLocn." 0:".$value[0]." 1:".$value[1]."\n";
          
          // Get proper incident title
          $newTitle = GetIncidentTitle($value[1]);
          
          $qInc = "SELECT InsertCHP(:loc, :deets, :titlename, :oride, :num)";
          $newInc = $db->prepare($qInc);
          $newInc->bindParam(':loc', $idLocn);
          $newInc->bindValue(':deets', 'Reported by CA Highway Patrol');
          $newInc->bindParam(':titlename', $newTitle);
          $newInc->bindValue(':oride', 1);
          $newInc->bindParam(':num', $value[0]);
          if($newInc->execute()) {
            echo "Created SceneAlert Incident #".$newInc->fetchColumn().".\n";
          } else {
            echo "Failed to create SceneAlert Incident due to a SQL Error.\n";
          }
        } else {
          echo "Failed to create SceneAlert Incident. No idLocation found.\n";
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
  echo "Cleaning up old CHP Incidents...\n";
  $q = "SELECT chp FROM incidents WHERE active = 1 AND chp IS NOT NULL";
  $oldInc = $db->prepare($q);
  if($oldInc->execute()) {
    echo "Found CHP Incidents in the MySQL Database.\n";
    while($row = $oldInc->fetch(PDO::FETCH_ASSOC)) {
      $in = $row['chp'];
      $stale = true;
      for($n = 0; $n < sizeof($newIncidents); $n++) {
        if(in_array($in, $newIncidents[$n])) {
          echo "INC #".$in." found. Event is still active.\n";
          $stale = false;
        }
      }
      if($stale) {
        echo "INC #".$in." stale. Removing!\n";
        $q = "UPDATE incidents SET active = 0 WHERE chp = :iNum";
        $closer = $db->prepare($q);
        $closer->bindParam(':iNum', $in);
        $closer->execute();
        if($closer) {
          echo "INC #".$in." closed successfully.\n";
        } else {
          echo "Failed to close INC #".$in."!\n";
        }  
      }
    } 
  }
?>





