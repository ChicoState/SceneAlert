
      var marks = []; // Keeps tracks of markers
      var gMap;
      
      
      /* HasMarker()
       * Checks if the marker to be created already exists
       */
      function HasMarker(idIncident) {
        for (var i = 0; i < marks.length; i++) {
          if (marks[i] == idIncident) {
            return true; // Marker Exists for idIncident
          }
        }
        return false; // No Marker
      }
      
      
      /* MarkerExpired()
       * Checks if any markers have expired / are no longer active
       * Works by taking a list of active call IDs, and checking the markers
       */
      function MarkerExpired(idList) {
        var contains = false;
        for (var i = 0; i < idList.length; i++) {
          if (marks.includes(idList[i])) {
            console.log('Marker ' + idList[i] + ' is still active. Ignoring.');
          } else {
            console.log('Marker ' + idList[i] + ' has expired. Removing.');
          }
        }
      }
      
      
      /* CreateMarker()
       * Creates a marker if it doesn't already exist
       * param Result {id, title, details, created, type, upvote, downvote}
       */
      function CreateMarker(latt, lngt, result) {
        if (!HasMarker(latt, lngt)) {
          console.log('Creating Marker ['+result[0])+']';
          var latLong = new google.maps.LatLng(latt, lngt);
          var marker  = new google.maps.Marker({
            position: latLong,
            map: gMap,
            title: result[1],
            icon: 'img/pins/' + result[4] + 's.png', // Choses icon img by type
            size: new google.maps.Size(26, 32),
            visible: true
          });
        
          marks.push(result[0]); // Add to marker tracker by idIncident
        
        } else {
          console.log('Marker ['+result[0]+'] exists');
        }
      }
      
      
      /* LoadMarkers()
       * Loads current incident markers when map loads
       */
      function LoadMarkers() {
        console.log('Loading Markers.');
        $.ajax({
          url: "php/incidents.php",
          success: function(result) {
            var jsn    = JSON.parse(result);
            var idList = [];
            for (var i = 0; i < jsn.length; i++) {
              
              // Go through and create a marker for each result from SQL
              CreateMarker(Number(jsn[i][2]), Number(jsn[i][1]), [
                jsn[i][0], jsn[i][3], jsn[i][5], jsn[i][4], jsn[i][6], jsn[i][7], jsn[i][8]
              ]);
              
              // Add to array of active calls, to check for expired markers
              idList.push(jsn[i][0]);
              
            }
            
            // Once markers are done being made, go through and remove exp'd
            MarkerExpired(idList);
            
          },
          error: function(result) {
            console.log("Failed. ["+result.responseText+"]");
          }
        });
        setTimeout(LoadMarkers, 10000);
      }
      
      
      /* initMap()
       * Initializes the Google Map upon page load
       */
      function initMap() {
        gMap = new google.maps.Map(document.getElementById('gmap'), {
          center: {lat: 37.0902, lng: -95.7129},
          zoom: 5,
          zoomControl: true,
          mapTypeControl: false,
          mapTypeId: 'terrain',
          scaleControl: true,
          streetViewControl: false,
          rotateControl: true,
          fullscreenControl: false
        });
        LoadMarkers();
      }