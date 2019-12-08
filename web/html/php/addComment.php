<?php
include('../inc/database.php');

    $idIncident = $_GET['incident'];
    $idParentComment = $_GET['parent'];
    $idUser = $_GET['userid'];
    $commentText = $_GET['comment'];
//insert into comments(idIncident, idParentComment, idUser, commentText) values(100340, NULL, 7, 'hi');
    $retarray = array();
    // if( $fetcher < 1 ) {
        $insertion = $db->prepare(
            "INSERT INTO comments (idIncident, idParentComment, idUser, commentText) VALUES ($idIncident, $idParentComment, $idUser,'$commentText')"
        );
        if( $insertion->execute() ) {
            $retarray[0] = 1;
            $retarray[1] = "Comment made";
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Error";
        }

    $db = null;
    exit();
?>
