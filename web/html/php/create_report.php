<?php
  require_once('../inc/database.php');
  if (session_status() == PHP_SESSION_NONE) {session_start();}
  
  $retarray = array();
  
  $posInfo = array(
    "loc"       => (!empty($_POST['locn'])     ? $_POST['locn']     : null),
    "name"      => (!empty($_POST['iName'])    ? $_POST['iName']    : null),
    "ctype"     => (!empty($_POST['iType'])    ? $_POST['iType']    : null),
    "reporter"  => (!empty($_POST['iReport'])  ? $_POST['iReport']  : null),
    "details"   => (!empty($_POST['iDetails']) ? $_POST['iDetails'] : null),
  );
  
  if (isset($posInfo["loc"])) {echo "1";} else {echo "X";}
  if (isset($posInfo["name"])) {echo "2";} else {echo "X";}
  if (isset($posInfo["ctype"])) {echo "3";} else {echo "X";}
  if (isset($posInfo["reporter"])) {echo "4";} else {echo "X";}
  if (isset($posInfo["details"])) {echo "5";} else {echo "X";}
  
  $iQuery = $db->prepare("CALL CreateReport(?, ?, ?, ?, ?)");
  $iQuery->bindParam(1, $posInfo['loc']);
  $iQuery->bindParam(2, $posInfo['name']);
  $iQuery->bindParam(3, $posInfo['ctype']);
  $iQuery->bindParam(4, $posInfo['reporter']);
  $iQuery->bindParam(5, $posInfo['details']);
  
  if ($iQuery->execute()) {
    $retarray[0] = 1;
    $retarray[1] = "Successful.";
  } else {
    $retarray[0] = 0;
    $retarray[1] = "Query Failed.";
  }
  
  echo json_encode($retarray);
  exit();
?>