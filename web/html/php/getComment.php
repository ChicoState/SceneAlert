<?php 
    include('../inc/database.php');

 $idIncident = $_GET['incident'];
    $errorMsg = NULL;
    $dataMsg = "";
	$dataArr = array();
    // if( $fetcher < 1 ) {
        $insertion = $db->prepare(
            "SELECT idComment, username, commentText
                FROM comments JOIN accounts
                ON comments.idUser = accounts.idUser
                WHERE idIncident = $idIncident"
        );
	
        if( $insertion->execute() ){ 
        $jsonarray = array();
        while( $row = $insertion->fetch(PDO::FETCH_ASSOC) ) {
                $jsonarray[] = array(
                    $row['idComment'], $row['username'], $row['commentText']
                );
            }
        $msg = json_encode( $jsonarray );
	$errorMsg = 1;
        }
        else {
            $errorMsg = 0;
            $msg = "Error";
        }
	$retarray = array($errorMsg, $msg);
	echo json_encode($retarray); 
    $db = null;
    exit();
?>
