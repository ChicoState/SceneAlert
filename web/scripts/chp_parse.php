<?php

  require_once('database.php');

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
  
  // Read older CHP XML. If not found, assume everything is a new incident
  $oldFile = fopen($read_new, "r");
  
  // Read through new file until we get to Chico Dispatch.
  $findChico   = 'Dispatch ID = "CHCC"';
  $isChico = false;

  while(!feof($newFile) or !$isChico) {
    $line = fgets($newFile);
    // If we found the Chico Dispatch Center, stop
    if (strpos($line, $findChico)) {
      echo "Found Chico Dispatch Center\n";
      $isChico = true;
      break;
    }
  }
  
  if ($isChico) {
    // Continue to loop as long as we're still in the Chico Dispatch Center
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
        echo "Creating MySQL Entry for new Incident: ".$value[0]."\n";
        
        // Check if Longitude / Latitude already exists
        $colon = strpos($value[3], ':');
        $lat = substr($value[3], 0, $colon);
        $long = substr($value[3], $colon + 1, strlen($value[3]));
        echo 'LAT('.$lat.')'."\n";
        echo 'LONG('.$long.')'."\n";
        $qGrid = "SELECT COUNT(*) FROM locations WHERE longitude = :long AND latitude = :lat";
        $gCheck = $db->prepare($qGrid);
        $gCheck->bindParam(':lat', $lat);
        $gCheck->bindParam(':long', $long);
        $gCheck->execute();
        
        $gridExists = $gCheck->fetchColumn();
        if ($gridExists < 1) {
          echo "Grid coordinates did not exist.\n";
        } else {
          echo "Grid coordinates exist!\n";
        }
        
      } else {
        echo "CHP Incident ".$value[0]." already in the MySQL Database!\n";
      }
    }
    echo "Script Finished.";
    
  }
  else {
    echo "Failed to find the Chico Dispatch Center in CHP XML.\n";
  }
  

?>