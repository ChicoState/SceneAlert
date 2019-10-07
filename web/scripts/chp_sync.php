<?php
  $chp_log = "https://media.chp.ca.gov/SA_XML/SA.xml";
  echo "\nPreparing to receive CHP Incidents XML.\n";
  if (!file_exists('files')) {
      mkdir('files', 0777, true);
  }

  // Checks if the files exist. If they do, handles accordingly
  if (file_exists("files/chp_incidents.xml")) {
    if (file_exists("files/chp_incidents_old.xml")) {
      unlink("files/chp_incidents_old.xml"); // Deletes the old file
    } else {
      echo "[chp_incidents_old.xml] Cannot remove - File Not Found. Ignoring.\n";
    }
    // Copy the existing file to _old
    echo "Renaming [chp_incidents.xml] to [chp_incidents_old.xml]...\n";
    copy("files/chp_incidents.xml", "files/chp_incidents_old.xml");
  } else {
    echo "[chp_incidents.xml] Not Found! Script cannot continue.\n";
  }
  
  // Download the latest CHP incident log
  $content = file_get_contents($chp_log);
  if ($content) {
    file_put_contents("files/chp_incidents.xml", $content);
    echo "Successfully obtained CHP Incident XML. Parsing...\n\n";
    include('chp_parse.php');
  }
  else {
    echo "Failed to obtain CHP Incident XML file from URL!\n";
    echo "Script was unable to continue. Terminating.\n\n";
  }
?>
