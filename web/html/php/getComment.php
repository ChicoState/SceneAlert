<?php 
    include('../inc/database.php');

 $idIncident = $_GET['incident'];
    $retarray = array();
    // if( $fetcher < 1 ) {
        $insertion = $db->prepare(
            "SELECT idComment, username, commentText
                FROM comments JOIN accounts
                ON comments.idUser = accounts.idUser
                WHERE idIncident = 100340"
        );
	
        if( $insertion->execute() ){ 
            if ($insertion->rowCount() > 0) {
              foreach($insertion->fetchAll() as $row) {
                array_push($retarray, array(
                  $row['idComment'], $row['username'], $row['commentText']
                ));
              }
	}
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Error";
        }
     echo json_encode($retarray);    
    $db = null;
    exit();
?>
