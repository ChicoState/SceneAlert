<?php
  require_once('../inc/database.php');
  
  $incidents = $db->prepare(
   "SELECT i.*,l.longitude,l.latitude,l.title AS titl
    FROM incidents i 
      LEFT JOIN locations l
      ON l.idLocation = i.idLocation
    WHERE active = 1"
  );
  $incidents->execute();
  
  $retarray = array();
  
  if ($incidents->rowCount() > 0) {
    foreach($incidents->fetchAll() as $row) {
      array_push($retarray, array(
        $row['idIncident'], $row['longitude'], $row['latitude'],
        $row['title'], $row['created'], $row['details'], $row['type'],
        $row['upvotes'], $row['downvotes']
      ));
    }
  }
  
  
  echo json_encode($retarray);
  exit();
?>