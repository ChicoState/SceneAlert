<?php
  require_once('../inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
  
  $retarray = array(); // For the end
  
  $posInfo = array(
    "num"    => (!empty($_POST['num'])    ? $_POST['num']    : null),
    "street" => (!empty($_POST['str'])    ? $_POST['str']    : null),
    "title"  => (!empty($_POST['title'])  ? $_POST['title']  : null),
    "zip"    => (!empty($_POST['postal']) ? $_POST['postal'] : null),
    "city"   => (!empty($_POST['city'])   ? $_POST['city']   : null),
    "state"  => (!empty($_POST['state'])  ? $_POST['state']  : null),
    "county" => (!empty($_POST['county']) ? $_POST['county'] : null),
    "nation" => (!empty($_POST['nation']) ? $_POST['nation'] : null),
    "long"   => (!empty($_POST['longt'])  ? $_POST['longt']  : null),
    "latt"   => (!empty($_POST['latt'])   ? $_POST['latt']   : null),
  );
  
  $insert = $db->prepare("SELECT NewLocation(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
  $insert->bindParam(1, $posInfo['num']);
  $insert->bindParam(2, $posInfo['street']);
  $insert->bindParam(3, $posInfo['title']);
  $insert->bindParam(4, $posInfo['zip']);
  $insert->bindParam(5, $posInfo['city']);
  $insert->bindParam(6, $posInfo['state']);
  $insert->bindParam(7, $posInfo['county']);
  $insert->bindParam(8, $posInfo['nation']);
  $insert->bindParam(9, $posInfo['long']);
  $insert->bindParam(10, $posInfo['latt']);
  
  if($insert->execute()) {
    $retarray[0] = 1;
    $retarray[1] = $insert->fetchColumn();
  } else {
    $retarray[0] = 0;
    $retarray[1] = "Failed to insert new location";
  }
  
  echo json_encode($retarray);
  exit();
  
?>