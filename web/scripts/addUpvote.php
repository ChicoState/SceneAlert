<?php
    include('database.php');

  // require_once('database.php');
  $err = NULL;
  $msg = "";

  $markId = $_POST['markId'];
  $query = "UPDATE incidents SET upvotes = 1 WHERE id= markId";
  $getCalls = $db->prepare($query);
  $getCalls->execute();
  
  $db = null;
  exit();
?>
