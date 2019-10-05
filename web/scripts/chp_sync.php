<?php
  $chp_log = "https://media.chp.ca.gov/SA_XML/SA.xml";
  
  if (!file_exists('files')) {
      mkdir('files', 0777, true);
  }

  // Checks if the files exist. If they do, handles accordingly
  if (file_exists("files/chp_incidents.xml")) {
    if (file_exists("files/chp_incidents_old.xml")) {
      unlink("files/chp_incidents_old.xml"); // Deletes the old file
    } else {
      echo "chp_incidents_old.xml Was not found\n";
    }
    // Copy the existing file to _old
    copy("files/chp_incidents.xml", "files/chp_incidents_old.xml");
  } else {
    echo "chp_incidents.xml Was not found.\n";
  }
  
  // Download the latest CHP incident log
  $content = file_get_contents($chp_log);
  if ($content) {
    file_put_contents("files/chp_incidents.xml", $content);
  }
  else {
    echo "Failed to read CHP's Incident XML file from URL!\n";
  }
  // Open the file for reading
  //$myfile = fopen("chp_incidents.xml", "r") or die("chp_incidents.xml NOT FOUND!!");
  //echo fread($myfile, filesize("chp_incidents.xml"));
  //fclose($myfile);
  
  echo "Finished. Parsing CHP XML.\n";
  shell_exec('php chp_parse.php');
?>
