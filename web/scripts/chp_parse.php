  
  <?php

  include('database.php');
  
  
  /* GetIncidentTitle()
    * Uses the first part of the CHP incident name to write a proper title
    * param name The unmodified title of the CHP Incident
    * returns String; "CHP Incident" if not found
    */
  function GetIncidentTitle($name) {
    
    if (!$name) {return "CHP Incident";}
    
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
      "WW" => "Wrong Way Vehicle",
      "SPINOUT" => "Vehicle Spinout",
      "FLOOD" => "Flooded Roadway",
      "SNOW" => "Heavy Snow",
      "CHAINS" => "Chains Required",
      "SLIDE" => "Mud/Rock Slide",
      "SILVER" => "Silver Alert",
      "AMBER" => "Amber Alert",
      "FOG" => "Dense Fog Advisory",
      "1184" => "Traffic Control in Effect",
      "SILVER Alert" => "Silver Alert",
      "TADV" => "Traffic Advisory",
      "JUMPER" => "Jumper",
      "1182" => "Non-Injury Collision",
      "1013" => "Adverse Road Conditions",
      "WIND Advisory" => "High Wind Advisory",
      "CLOSURE" => "Road Closure",
      "CLOSURE of a Road" => "Road Closure",
      "1166" => "Suspicious Vehicle",
      "SIG Alert" => "Travel Alert",
      "23114" => "Objects Falling from Insecure Load",
      "WW" => "Wrong-way Driver"
    );
    
    $temp = explode('-', $name)[0];
    if ($temp) {return ($titles[$temp] ? $titles[$temp] : "CHP Incident");}
    return "CHP Incident";
  }
  
  /* DetermineService()
    * Checks if the CHP incident involves fire/police and changes type accordingly
    * 1=Police 2=Hazard 4=EMS 8=Military (7: Fire/Police/EMS)
    */
  function DetermineService($name) {
    if (!$name) {return 1;} // If no title given, assume it's a CHP Police issue
    $agencies = array(
      "1144"    => 4, "1179" => 4, "1180" => 4, "1181" => 4,
      "1183"    => 4, "20001" => 4, "CFIRE" => 2, "FIRE" => 2,
      "SPINOUT" => 4, "SLIDE" => 1, "SILVER" => 1, "SNOW" => 1,
      "CHAINS"  => 1, "WIND" => 1, "20002" => 1, "1125" => 1,
      "FLOOD"   => 1, "AMBER" => 1, "FOG" => 4, "1184" => 1,
      "SILVER Alert" => 1, "TADV" => 1, "JUMPER" => 4,
      "1182" => 1, "1013" => 1, "WIND Advisory" => 4,
      "CLOSURE" => 4, "CLOSURE of a Road" => 4,
      "1166" => 1, "SIG Alert" => 4, "23114" => 1,
      "WW" => 4
    );
    $temp = explode('-', $name)[0];
    if ($temp) {return ($agencies[$temp] ? $agencies[$temp] : 1);}
    return 1; // Assume a police issue
  }


  echo "Preparing to parse [chp_incidents.xml].\n";

  // Variable init
  $read_new = "files/chp_incidents.xml";
  
  /*   Organization:
    $newIncidents = {
       [0] = (Log ID)
       [1] = (LogType/The type of Call),
       [2] = (Latitude),
       [3] = (Longitude),
       [4] = (Details)
    }
  */
  // Read latest CHP XML. If not found, terminate
  $newIncidents = array();
  $newFile = fopen($read_new, "r") or die("Failed to read chp_incidents.xml.\n");
  
  $findLog = 'Log ID';
  while(!feof($newFile)) {
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
      
      // Next line, until "</LogDetails>" is is the...well, details.
      $line    = fgets($newFile);
      $stopper = "</LogDetails>";
      $deets   = "";
      while (strpos($line, $stopper) == False) {
        if (strpos($line, "<IncidentDetail>")) {
          preg_match_all('/<IncidentDetail>\"(.*?)\"<\/IncidentDetail>/s', $line, $matches);
          $deets = $deets . implode(' ', $matches[1]) . "\r\n";
        }
        $line = fgets($newFile);
      }
      
      if ($deets == "") { $deets = "Reported by CHP Dispatch\r\n"; }
      $newIncidents[] = array($log, $type, $loc, $latlong, $deets);
    }
  }
  echo "Received ".count($newIncidents)." Incidents.";
  foreach($newIncidents as $key => $value) {
    
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
      $long = "-" . substr($value[3], $colon + 1, strlen($value[3]));
      $latitude  = substr_replace($lat,  '.', 2, 0);
      $longitude = substr_replace($long, '.', 4, 0);
        
      $qGrid = "SELECT COUNT(*) AS count,idLocation AS id FROM locations WHERE longitude = :long AND latitude = :lat";
      $gCheck = $db->prepare($qGrid);
      $gCheck->bindParam(':lat', $latitude);
      $gCheck->bindParam(':long', $longitude);
      $gCheck->execute();
      
      $fetcher = $gCheck->fetch(PDO::FETCH_ASSOC);
      $locExist = $fetcher['count'];
      $idLocn = $fetcher['id'];
      if ($locExist < 1) {
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
        }
      }
      if ($idLocn) {
        
        $qInc = "SELECT InsertCHP(:loc, :deets, :ctype, :titlename, :oride, :num)";
        $newInc = $db->prepare($qInc);
        $newInc->bindParam(':loc', $idLocn);
        $newInc->bindValue(':deets', $value[4]);
        $newInc->bindValue(':ctype',     DetermineService($value[1]));
        $newInc->bindParam(':titlename', GetIncidentTitle($value[1]));
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
  $db = null;
?>





