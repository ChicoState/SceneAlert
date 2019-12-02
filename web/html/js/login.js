
      
      function HideLogin() {
        $("#acct-details").fadeOut(200);
      };
      
      
      function SubmitFormData() {
        
        var usr = $("#uname").val();
        var pwd = $("#passwd").val();
        
        $("#uname").val(""); $("#passwd").val("");
        $("#login-msg").html("PLEASE WAIT");
        
        $.ajax({
          url: '../php/login.php',
          type: 'POST',
          data: {user: usr, pass: pwd},
          success: function(result) {
            
            var answer = jQuery.parseJSON(result);
            console.log( 'Bit Flag: ' + answer[0] );
            console.log( 'Response: ' + answer[1] );
            
            // Hide login window on success & reload navbar
            if (answer[0] == 1) {
              $("#acct-details").fadeOut(200);
              $("#topdiv").load("topbar.php");      // Reload topbar
              $("#calldiv").load("controller.php"); // Load call controller
              console.log("LOADED CALLDIV");
            }
            
          }
        });
      };
      
      
      function doLogoff() {
        console.log('Received Logoff');
        $.ajax({
          url: '../php/logout.php',
          success: function() {
            console.log('Success!');
            $("#topdiv").load("topbar.php"); // Reload topbar
            $("#calldiv").empty(); // Remove call controls
            $("#uname").val('');
            $("#passwd").val('');
            $("#acct-details").fadeIn(200);
            console.log('Finished.');
          },
          error: function(result) {
            console.log('Failure; ' + result.responseText)
          }
        });
        console.log('END~doLoggoff()');
      };
      
      // Show the login block
      function ShowLoginBlock() {
        $("#acct-details").fadeIn(200);
      }