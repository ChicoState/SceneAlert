<?php
	require_once('../inc/database.php');
  ERROR_REPORTING(E_ALL);
?>

<head>
  <title>DEBUG - Register</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
  $(document).ready(function(){
    $("#cpass").keyup(function(){
      if ($("#pass").val() != $("#cpass").val()) {
        $("#warning").html("Passwords do not match").css("color","red");
      }else{
        $("#warning").html("Password OK").css("color","green");
        }
    });
  });
	</script> 
</head>
<body>
  <div id="loginscreen">
    <div id="loginblock">

<?php

  // Validate the e-mail passed in
  if($_GET['do'] == "register") {
    $cpuser = ($_POST['cpuser']);
    echo $cpuser.'<br/>';
    if (!filter_var($cpuser, FILTER_VALIDATE_EMAIL)) {
      echo "Invalid e-mail address given";
      
    } else {
      echo "E-Mail Address Validated<br/>";
      $pass   = $_POST['pass'];
      $cpass  = $_POST['cpass'];
      if(empty($pass)||empty($cpass)) {
        echo "All fields must be completed. Registration canceled.<br/>";
        
      } else {
        echo "Challenges Presented.<br/>";
        if($pass == $cpass) {
          echo "Challenges Matched.<br/>";
          $phash = password_hash($pass, PASSWORD_DEFAULT);	
          $stmt  = $db->prepare(
            "SELECT COUNT(*) FROM accounts WHERE email = :user"
          );
          $stmt->bindParam(':user', $cpuser);
          $stmt->execute();
          
          $fetcher = $stmt->fetchColumn();
          
          if($fetcher < 1) {
            echo "E-Mail Not Already Used.<br/>";
            $insertion = $db->prepare(
              "INSERT INTO accounts (email, hash) VALUES (:user, :phash)"
            );
            $insertion->bindParam(':user',  $cpuser);
            $insertion->bindParam(':phash', $phash);
            if($insertion->execute()) {
              echo "User <strong>".$cpuser."</strong> created.";
            }
            else
            {
              echo "Unable to create account.<br/>";
              echo "Error Dump:<br/>".var_dump($insertion->errorInfo())."<br/><br/>";
            }
          } else {
            echo "This e-mail already exists<br/>";
          }
        } else {
          echo "Passwords did not match. Please try again.<br/>";
        }
      }
    }
  }
?>
		<form method="POST" action="?do=register">
		<table>
			<tr>
				<th>E-Mail Address:</th>
				<td><input type="text" name="cpuser" placeholder="admin@scene-alert.com"/></td>
			</tr>
			<tr>
				<th>Password:</th>
				<td><input type="password" id="pass" name="pass"/></td>
			</tr>
			<tr>
				<th>Confirm:</th>
				<td><input type="password" id="cpass" name="cpass"/></td>
			</tr>
			<tr>
				<td id="warning"></td>
				<td><input type="submit" value="Submit" /></td>
			</tr>
		</table>
		</form><br/><br/>
    </div>
  </div>
</body>
