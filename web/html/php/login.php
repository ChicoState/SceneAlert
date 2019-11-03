<?php
	$usr     = $_POST['user'];
	$pass    = $_POST['pass'];
	$stmt    = $db->prepare(
    "SELECT * FROM accounts WHERE email = :user LIMIT 1"
  );
	$stmt->bindParam(':user', $usr);
	$stmt->execute();
	$acct = $stmt->fetch();
  
  // If result exists, verify the information
  $retarray = array();
	if($acct) {
    if($acct['rank'] < 1) {
      array_push($retarray, 0); // 0 indicates failure 
      array_push($retarray, "This account has been banned"); 
    }
    elseif (password_verify($pass, $acct['hash'])) {
			
			// Set session variables
			$_SESSION['user']  = $acct['idUser'];	// Username 
			$_SESSION['rank']  = $qfetch['rank'];     // Permission level [0=Ban, 2=Admin]
      
      array_push($retarray, 1); // 1 indicates login success
      array_push($retarray, "Login was Successful"); 
      
		} else {
      array_push($retarray, 0); // 0 indicates login failure
      array_push($retarray, "Username/Password Incorrect"); 
    }
  } else {
    array_push($retarray, (-1)); // -1 indicates an error
    array_push($retarray, "That e-mail is not registered"); 
  }
  echo json_encode($retarray);
  exit();
?>