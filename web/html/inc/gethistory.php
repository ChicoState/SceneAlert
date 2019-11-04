<?php
    require_once('../inc/database.php');
    if (session_status() == PHP_SESSION_NONE) {session_start();}
  
    $timeRange = $_GET['range'];
    $err = NULL;
    $msg = "";
  
    $dbQuery = NULL;
    if( $timeRange == '1day' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 1 DAY"
        );
    }
    elseif( $timeRange == '1week' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 1 WEEK"
        );
    }
    elseif( $timeRange == '1month' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 1 MONTH"
        );
    }
    elseif( $timeRange == '3month' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 3 MONTH"
        );
    }
    elseif( $timeRange == '6month' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 6 MONTH"
        );
    }
    elseif( $timeRange == '1year' ) {
        $dbQuery = $db->prepare(
            "SELECT * FROM incidents WHERE created > NOW() - INTERVAL 1 YEAR"
        );
    }

    if( $dbQuery->execute() ) {
        $err = 0;
        $jsonarray = array();
        while( $row = $dbQuery->fetch(PDO::FETCH_ASSOC) ) {
            $jsonarray[] = array(
                $row['title'], $row['details'], $row['type']
            );
        }
        $msg = json_encode( $jsonarray );
    }
    else {
        $err = 1;
        $msg = "Unable to execute query";
    }
  

    $retarray = array( $err, $msg );

    echo json_encode($retarray);

    exit();
?>
