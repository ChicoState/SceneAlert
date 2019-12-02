<?php
    require_once('../inc/database.php');
    if (session_status() == PHP_SESSION_NONE) {session_start();}

  // require_once('database.php');
  $err = NULL;
  $msg = "";

  $markId = $_POST['markId'];
  $query = "UPDATE incidents SET upvotes = 1 WHERE id= markId";
  $getCalls = $db->prepare($query);
  $getCalls->execute();
  
  exit();
?>
