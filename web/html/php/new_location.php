<?php
  require_once('../inc/database.php');
  echo "Hello!";
  if (session_status() == PHP_SESSION_NONE) {session_start();}
  
  echo "Ready!";
  
  $retarray = array(); // For the end
  
  echo "Array Building!";
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
  echo "Array READY!";
  
  if (isset($posInfo["num"])) {echo "1";} else {echo "X";}
  if (isset($posInfo["street"])) {echo "2";} else {echo "X";}
  if (isset($posInfo["title"])) {echo "3";} else {echo "X";}
  if (isset($posInfo["zip"])) {echo "4";} else {echo "X";}
  if (isset($posInfo["city"])) {echo "5";} else {echo "X";}
  if (isset($posInfo["state"])) {echo "6";} else {echo "X";}
  if (isset($posInfo["county"])) {echo "7";} else {echo "X";}
  if (isset($posInfo["nation"])) {echo "8";} else {echo "X";}
  if (isset($posInfo["long"])) {echo "9";} else {echo "X";}
  if (isset($posInfo["latt"])) {echo "0";} else {echo "X";}
  
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
  
  echo "Query Ready!";
  
  if($iQuery->execute()) {
  echo "EXECUTED!";
    $retarray[0] = 1;
    $retarray[1] = $iQuery->fetchColumn();
  } else {
  echo "FAILED!";
    $retarray[0] = 0;
    $retarray[1] = "Failed to insert new location";
  }
  
  echo "Closing!";
  echo json_encode($retarray);
  exit();
  
?>