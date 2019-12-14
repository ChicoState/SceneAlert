<?php
    include('database.php');

    $lat = $_GET['lat'];
    $lon = $_GET['lon'];
    $radius = $_GET['radius'];
    $timeRange = $_GET['time'];
    $err = NULL;
    $msg = "";

    function getRadius( $latArg, $longArg, $latDb, $longDb ) {

        // Converts all the lat/longs to radians
        $latArg = deg2rad($latArg);
        $longArg = deg2rad($longArg);
        $latDb = deg2rad($latDb);
        $longDb = deg2rad($longDb);

        // Haversine formula
        // Calculates the distance between 2 lat/longs and gives result in km
        $result = 6371 * acos( sin($latArg) * sin($latDb) + cos($latArg) * cos($latDb) * cos($longDb - $longArg));

        // Returns the result in miles
        return $result/1.609;
    }
  
    $dbQuery = NULL;
    if( $timeRange == '1day' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 1 DAY"
        );
    }
    elseif( $timeRange == '1week' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 1 WEEK"
        );
    }
    elseif( $timeRange == '1month' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 1 MONTH"
        );
    }
    elseif( $timeRange == '3month' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 3 MONTH"
        );
    }
    elseif( $timeRange == '6month' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 6 MONTH"
        );
    }
    elseif( $timeRange == '1year' ) {
        $dbQuery = $db->prepare(
            "SELECT inc.*,loc.longitude,latitude FROM incidents inc 
            LEFT JOIN locations loc ON loc.idLocation = inc.idLocation 
            WHERE created > NOW() - INTERVAL 1 YEAR"
        );
    }

    if( $dbQuery->execute() ) {
        $err = 0;
        $jsonarray = array();
        while( $row = $dbQuery->fetch(PDO::FETCH_ASSOC) ) {
            $rowRadius = getRadius( $lat, $lon, $row['latitude'], $row['longitude'] );
            if( $rowRadius <= $radius ) {
                $jsonarray[] = array(
                    $row['title'], $row['type'], $row['details'], $row['created']
                );
            }
        }
        $msg = json_encode( $jsonarray );
    }
    else {
        $err = 1;
        $msg = "Unable to execute query";
    }
  

    $retarray = array( $err, $msg );

    echo json_encode($retarray);
    $db = null;
    exit();
?>
