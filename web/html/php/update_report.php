<?php
  include('../inc/database.php');
  
  $retarray = array(); // For the end
  
  // TODO: Verify the updater is an admin or the original reporter
  
    // If they're not, submit it as a comment.
  
  // Get the existing notes from the given report
  
  // Get the note that the user wants to add
  
  // Fix a timestamp to the new note, as well as their username
  
  // Update the existing report details
  
  // Return the new details with the user's note to ajax.
  
  // TODO: Broadcast the change to all active users so they see the new notes, too
  
  echo json_encode($retarray);
  $db = null;
  exit();
  
?>