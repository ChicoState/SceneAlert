<?php
  include('../inc/database.php');
  
  $closeR = $db->prepare("UPDATE incidents SET active = 0 WHERE idIncident = :dbid");
  $closeR->bindParam(':dbid', $_POST['dbid']);
  
  $retarray = array([0] => $closeR->execute(), [1] => "Query Executed.");
  
  echo json_encode($retarray);
  $db = null;
  exit();
  
?>