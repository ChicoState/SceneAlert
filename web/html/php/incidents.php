<?php
  include('../inc/database.php');
  
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
      if (!$row['idCreator']) { $row['idCreator'] = 0; }
      $getmaker = $db->prepare(
        "SELECT username FROM accounts WHERE idUser = :uid"
      );
      $getmaker->bindParam(':uid', $row['idCreator']);
      $getmaker->execute();
      $name = $getmaker->fetchColumn();
      array_push($retarray, array(
        $row['idIncident'], // 0
        $row['longitude'],  // 1
        $row['latitude'],   // 2
        $row['title'],      // 3
        $row['created'],    // 4
        $row['details'],    // 5
        $row['type'],       // 6
        $row['upvotes'],    // 7
        $row['downvotes'],  // 8
        $name               // 9
      ));
    }
  }
  
  
  echo json_encode($retarray);
  $db = null;
  exit();
?>