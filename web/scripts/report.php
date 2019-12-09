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

        if ($iQuery->execute()) {
            $retarray[0] = 1;
            $retarray[1] = "Successful.";
        } else {
            $retarray[0] = 0;
            $retarray[1] = "Query Failed.";
        }

        echo json_encode($retarray);
    }
    else {
        echo "Not found";
        echo $searchLocation->fetch(PDO::FETCH_ASSOC);
    }

    $db = null;
    exit();
?>
</pre>