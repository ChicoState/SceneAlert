<pre>
<?php
    include('database.php');
    if (session_status() == PHP_SESSION_NONE) {session_start();}

    $lat = $_GET['lat'];
    $lon = $_GET['lon'];
    $idLocation = -1;

    $searchLocation = $db->prepare(
        "SELECT idLocation, latitude, longitude from locations where latitude = $lat AND longitude = $lon"
    );

    if( $searchLocation->execute() ) {
        echo "Found\n";
        $idLocation = $searchLocation->fetch(PDO::FETCH_ASSOC)['idLocation'];

        echo "Id location = $idLocation\n";

        $retarray = array();

        $posInfo = array(
            "loc" => ( $idLocation ),
            "title" => ( $_GET['title'] ),
            "ctype" => ( $_GET['type'] ),
            "reporter" => ( $_GET['reporter'] ),
            "details" => ( $_GET['details'] ),
        );

        print_r($posInfo);

        $iQuery = $db->prepare("CALL CreateReport(?, ?, ?, ?, ?)");
        $iQuery->bindParam(1, $posInfo['loc']);
        $iQuery->bindParam(2, $posInfo['title']);
        $iQuery->bindParam(3, $posInfo['ctype']);
        $iQuery->bindParam(4, $posInfo['reporter']);
        $iQuery->bindParam(5, $posInfo['details']);

        if( $iQuery->execute() ) {
            $retarray[0] = 1;
            $retarray[1] = "Successful.";
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Query Failed.";
        }

        echo json_encode($retarray);
    }
    else {
        echo "Not found\n";
        
        $retarray = array(); // For the end
  
        $posInfo = array(
            "num"    => $_GET['num'] ),
            "street" => $_GET['str'] ),
            "title"  => $_GET['title'] ),
            "zip"    => $_GET['postal'] ),
            "city"   => $_GET['city'] ),
            "state"  => $_GET['state'] ),
            "county" => $_GET['county'] ),
            "nation" => $_GET['nation'] ),
            "long"   => $_GET['longt'] ),
            "latt"   => $_GET['latt'] ),
        );

        $iQuery = $db->prepare("SELECT NewLocation(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $iQuery->bindParam(1,  $posInfo['num']);
        $iQuery->bindParam(2,  $posInfo['street']);
        $iQuery->bindParam(3,  $posInfo['title']);
        $iQuery->bindParam(4,  $posInfo['zip']);
        $iQuery->bindParam(5,  $posInfo['city']);
        $iQuery->bindParam(6,  $posInfo['state']);
        $iQuery->bindParam(7,  $posInfo['county']);
        $iQuery->bindParam(8,  $posInfo['nation']);
        $iQuery->bindParam(9,  $posInfo['long']);
        $iQuery->bindParam(10, $posInfo['latt']);

        if($iQuery->execute()) {
            $retarray[0] = 1;
            $retarray[1] = $iQuery->fetchColumn();
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Failed to insert new location";
        }

        echo json_encode($retarray);
    }

    $db = null;
    exit();
?>
</pre>