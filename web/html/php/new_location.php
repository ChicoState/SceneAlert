<?php
  include('../inc/database.php');
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
  
  $iQuery = $db->prepare("SELECT NewLocation(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
  $iQuery->bindParam(1,  $posInfo['num']);
  $iQuery->bindParam(2,  $posInfo['street']);
  $iQuery->bindParam(3,  $posInfo['title']);
  $iQuery->bindParam(4,  $posInfo['zip']);
  $iQuery->bindParam(5,  $posInfo['city']);
  $iQuery->bindParam(6,  $posInfo['state']);
  $iQuery->bindParam(7,  $posInfo['county']);
  $iQuery->bindParam(8,  $posInfo['nation']);
  $iQuery->bindParam(9,  $posInfo['long']);
  $iQuery->bindParam(10, $posInfo['latt']);
  
  if($iQuery->execute()) {
    $retarray[0] = 1;
    $retarray[1] = $iQuery->fetchColumn();
  } else {
    $retarray[0] = 0;
    $retarray[1] = "Failed to insert new location";
  }
  
  echo json_encode($retarray);
  $db = null;
  exit();
  
?>