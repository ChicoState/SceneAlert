<?php
    require_once('../inc/database.php');
    ERROR_REPORTING(E_ALL);

    $idIncident = $_GET['incident'];
    $idParentComment = $_GET['parent'];
    $idUser = $_GET['user'];
    $commentText = $_GET['comment'];

    // $stmt  = $db->prepare(
    //     "SELECT COUNT(*) FROM accounts WHERE email = $email"
    // );
    // $stmt->bindParam(':user', $cpuser);
    // $stmt->execute();
    
    // $fetcher = $stmt->fetchColumn();

    $retarray = array();
    
    // if( $fetcher < 1 ) {
        $insertion = $db->prepare(
            "INSERT INTO comments (idIncident, idParentComment, idUser, commentText) VALUES ('$idIncident', '$idParentComment', '$idUser', '$commentText')"
        );
        if( $insertion->execute() ) {
            $retarray[0] = 1;
            $retarray[1] = "Comment made";
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Error";
        }
    // }
    // else {
    //     $retarray[0] = 0;
    //     $retarray[1] = "Error";
    // }

    echo json_encode($retarray);
    exit();
?>
