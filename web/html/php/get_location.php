<?php
  require_once('../inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
  
  $retarray = array();
  $useAddress = isset($_POST['aNumber']) && isset($_POST['aStreet']) && isset($_POST['aZip']);
  $useCoords  = isset($_POST['longitude']) && isset($_POST['latitude']);
  $useZip     = isset($_POST['aZip'])
  $useCity    = isset($_POST['aCity'] && isset($_POST['aState'])
  
  $cInfo = array(
    $_POST['aNumber'],   $_POST['aStreet'],  $_POST['aZip'],
    $_POST['aCity'],     $_POST['aState'],
    $_POST['longitude'], $_POST['latitude']
  );
  
  if ($useAddress or $useCoords) {
    
    $qryString = "SELECT idLocation FROM locations ";
    $locn;
    
    // Use Street Address (We prefer this as it's not as precise)
    if ($useAddress) {
      
      $locn = $db->prepare($qryString . "
        WHERE house_number = :num
        AND LOWER(street) LIKE LOWER('%:st%')
        AND zipcode = :zip
      ");
      $locn->bindParam(':num', $cInfo[0]);
      $locn->bindParam(':st', $cInfo[1]);
      $locn->bindParam(':zip', $cInfo[2]);
      
    // Use coordinates (Requires more precision, most likely won't be found)
    } else {
      
      // DEBUG - To be added
      // Before we make a Google API request,
      // make sure we don't have a nearby address that we can use first
      
      $locn = $db->prepare($qryString . "
        WHERE longitude = :long AND latitude = :latt
      ");
      $locn->bindParam(':long', $cInfo[5]);
      $locn->bindParam(':latt', $cInfo[6]);
      
    }
    
    if($locn->execute()) {
      $idLoc = $locn->fetchColumn();
      
      // idLocation exists in the SQL Database! USE IT!!
      if ($idLoc) {
        $retarray[0] = 1;
        $retarray[1] = $idLoc;
      } else {
        // Lovely... Now we have to pay for a Google Maps API Geolocation
        $retarray[0] = 0;
        $retarray[1] = "Location not found, we will have to use GeoLocation.";
      }
      
    } else {
      $retarray[0] = (-1);
      $retarray[1] = "SQL Failed: " . $db->errorInfo()[1];
    }
    
  }
  else {
    $retarray[0] = (0);
    $retarray[1] = "A Full Address & Zip Code /OR/ Longitude & Latitude Required";
    
  }
  echo json_encode($retarray);
  exit();
  
?>