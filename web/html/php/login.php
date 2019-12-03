<?php
  include('../inc/database.php');
  
	$usr = $_POST['user'];
	$pass = $_POST['pass'];
  
	$stmt = $db->prepare(
        "SELECT * FROM accounts WHERE email = :user LIMIT 1"
    );
	$stmt->bindParam(':user', $usr);
  
    $retarray = array();
	if( $stmt->execute() ) {
        $acct = $stmt->fetch();
        if($acct) {
            if($acct['rank'] < 1) {
                $retarray[0] = 0; // 0 indicates failure 
                $retarray[1] = "Account has been banned"; 
            }
            elseif( password_verify($pass, $acct['hash']) ) {
                // Set session variables
                $_SESSION['user']  = $acct['idUser'];	// Username 
                $_SESSION['rank']  = $acct['rank']; // Permission level [0=Ban, 2=Admin]
                $_SESSION['email'] = $acct['email'];
                
                $retarray[0] = 1; // 1 indicates login success
                $retarray[1] = "Login was Successful";
            }
            else {
                $retarray[0] = 0; // 0 indicates login failure
                $retarray[1] = "Username/Password Incorrect";
            }
        }
        else {
            $retarray[0] = (-1); // -1 indicates an error
            $retarray[1] = "That e-mail is not registered";
        }
    }
    else {
        $retarray[0] = (-1);
        $retarray[1] = "The SQL Query Failed";
    }

    // If result exists, verify the information
    echo json_encode($retarray);
    $db = null;
    exit();
?>