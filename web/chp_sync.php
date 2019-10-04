<?php
  
  $chp_log = "https://media.chp.ca.gov/SA_XML/SA.xml";

  // Checks if the files exist. If they do, handles accordingly
  if (file_exists("chp_incidents.xml")) {
    if (file_exists("chp_incidents_old.xml")) {
      unlink("chp_incidents_old.xml"); // Deletes the old file
    }
    // Copy the existing file to _old
    copy("chp_incidents.xml", "chp_incidents_old.xml");
  }
  
  // Download the latest CHP incident log
  $content = file_get_contents($chp_log);
  if ($content) {
    file_put_contents("chp_incidents.xml", $content);
  }
  else {
    echo "Failed to read CHP's Incident XML file from URL!";
  }
  // Open the file for reading
  $myfile = fopen("chp_incidents.xml", "r") or die("chp_incidents.xml NOT FOUND!!");
  echo fread($myfile, filesize("chp_incidents.xml"));
  fclose($myfile);
  
  echo "Script Complete.\n\n";
?>
