<?php

  require_once('database.php');
  $err = NULL;
  $msg = "";

  $lat = $_GET['lat'];
  $lon = $_GET['lon'];
  $range = $_GET['range'];

  function getRadius( $latArg, $longArg, $latDb, $longDb ) {
    
    // Converts all the lat/longs to radians
    $latArg = deg2rad($latArg);
    $longArg = deg2rad($longArg);
    $latDb = deg2rad($latDb);
    $longDb = deg2rad($longDb);
    
    // Haversine formula
    // Calculates the distance between 2 lat/longs and gives result in km
    $result = 6371 * acos( sin($latArg) * sin($latDb) + cos($latArg) * cos($latDb) * cos($longDb - $longArg));

    // Returns the result in miles
    return $result/1.609;
  }

  $query = "SELECT inc.*,loc.longitude,loc.latitude
            FROM incidents inc
            LEFT JOIN locations loc 
              ON loc.idLocation = inc.idLocation
            WHERE active = 1";

  $getCalls = $db->prepare($query);
  if ($getCalls->execute()) {
    $err = 0;
    $jsonarray = array();
    while($row = $getCalls->fetch(PDO::FETCH_ASSOC)) {
      $radius = getRadius( $lat, $lon, $row['latitude'], $row['longitude'] );
      if( $radius <= $range ) {
        $jsonarray[] = array(
            $row['title'], $row['type'], $row['details'],
            $row['longitude'], $row['latitude']
        );
      }
    }
    $msg = json_encode($jsonarray);

  } else {
    $err = 1;
    $msg = "Unable to execute MySQL Query";
  }

  $retarray = array($err, $msg);

  echo json_encode($retarray);
  exit();
?>
