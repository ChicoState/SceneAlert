
      // Load-in the call controller if logged in
      // This is used if they started the page not logged in at first
      function LoadCallControl() {
        $("#calldiv").load("controller.php");
      }
      
      function CreateIncident(cInfo) {
        console.log('Creating Incident!');
        console.log(cInfo);
      }
      
      // Handles the controller.php function(s)
      function NewCallCreate() {
        var cInfo = {
          stnum: $('#new-stnumber').val(),
          stname: $('#new-stname').val(),
          zip: $('#new-zip').val(),
          city: $('#new-city').val(),
          state: $('#new-state').val(),
          ctype: $('#new-type').val(),
          ctitle: $('#new-title').val(),
          detail: $('#new-details').val()
        };
        
        $('#new-stnumber').val('');
        $('#new-stname').val('');
        $('#new-zip').val('');
        $('#new-city').val('');
        $('#new-state').val('');
        $('#new-type').val('');
        $('#new-title').val('');
        $('#new-details').val('');
        
        
        // Request previously saved location from SQL
        $.ajax({
          url: '../php/get_location.php',
          type: 'POST',
          data: {
            aNumber: cInfo.stnum, aStreet: cInfo.stname,
            aZip: cInfo.zip, aCity: cInfo.city,
            aState: cInfo.state
          },
          success: function(result) {
            
            var answer = jQuery.parseJSON(result);
            console.log( 'Bit Flag: ' + answer[0] );
            
            // Use location value to create the new incident
            if (answer[0] > 0) {
              console.log('Found idLocation');
              CreateIncident(cInfo, answer[1]);
            
            // DEBUG - Log why it failed
            } else {console.log(answer[1]);}
            
          },
          error: function(result) {
            console.log( 'Failed. Response: ' + result.responseText );
          }
        });
        
        
      }