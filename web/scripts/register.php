<?php
    require_once('../inc/database.php');
    ERROR_REPORTING(E_ALL);

    $user = $_GET['user'];
    $email = $_GET['email'];
    $pass = $_GET['pass'];

    $phash = password_hash($pass, PASSWORD_DEFAULT);	
    $stmt  = $db->prepare(
        "SELECT COUNT(*) FROM accounts WHERE email = $email"
    );
    $stmt->bindParam(':user', $cpuser);
    $stmt->execute();
    
    $fetcher = $stmt->fetchColumn();

    $retarray = array();
    
    if( $fetcher < 1 ) {
        $insertion = $db->prepare(
            "INSERT INTO accounts (email, hash, username) VALUES ($email, $phash, $user)"
        );
        if( $insertion->execute() ) {
            echo "User <strong>".$user."</strong> created.";
            $retarray[0] = 1;
            $retarray[1] = "$user successfully made.";
        }
        else {
            $retarray[0] = 0;
            $retarray[1] = "Other error";
        }
    }
    else {
        $retarray[0] = 0;
        $retarray[1] = "Email is already used.";
    }

    echo json_encode($retarray);
    exit();
?>
