<?php

  require_once('database.php');
  $err = NULL;
  $msg = "";

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
      $jsonarray[] = array(
         $row['title'], $row['type'], $row['details'],
         $row['longitude'], $row['latitude']
      );
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
