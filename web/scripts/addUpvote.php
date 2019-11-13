<?php

  require_once('database.php');
  $err = NULL;
  $msg = "";

  $upvote = $_POST['upvote'];
  $query = "UPDATE incidents SET upvotes = 1 WHERE id= upvote";

  
  exit();
?>
