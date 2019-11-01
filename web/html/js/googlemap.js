
      var marks = []; // Keeps tracks of markers {0:idIncident, 1:Object}
      var listn = []; // List of listeners {0:idIncident, 1:Object}
      var gMap;
      
      
      /* HasMarker()
       * Checks if the marker to be created already exists
       */
      function HasMarker(idIncident) {
        for (var i = 0; i < marks.length; i++) {
          if (marks[i][0] == idIncident) {
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
        var expired  = [];
        // Checking the list of existing markers
        for (var i = 0; i < marks.length; i++) {
          // Against the list of active incidents
          var idExists = false;
          for (var j = 0; j < idList.length; j++) {
            if (marks[i][0] == idList[j]) {
              idExists = true;
              j = idList.length; // End Loop
            }
          }
          
          // If incident doesn't exist (is inactive), remove stuff
          if (!idExists) {
            marks[i][1].setMap(null); // Remove Marker
            expired.push(marks[i][0]); // Add to array for deletion
          }
        }
        
        // Remove all expired entries and remove from 'marks'
        for (var i = 0; i < expired.length; i++) {
          for (var j = 0; j < marks.length; j++) {
            if (marks[j][0] == expired[i]) {
              marks.splice(j, 1); // Remove from Markers Array
              listn.splice(j, 1); // Remove corresponding listener
              j = marks.length; // Safe Break the Loop
            }
          }
        }
      }
      
      
      function GetMarkerColor($cType) {
        if ($cType == 1) {return '#0bf';}
        else if ($cType ==2) {return '#f50';}
        else if ($cType == 3) {return '#ddd';}
        else if ($cType == 5) {return '#0a0';}
        return '#fff';
      }
      
      function getWidth() {
        if (self.innerWidth) {
          return self.innerWidth;
        }
      
        if (document.documentElement && document.documentElement.clientWidth) {
          return document.documentElement.clientWidth;
        }
      
        if (document.body) {
          return document.body.clientWidth;
        }
      }
      
      /* CreateMarker()
       * Creates a marker if it doesn't already exist
       * param Result {[0]id, title, details, created, type, upvote, downvote}
       */
      function CreateMarker(latt, lngt, result) {
        if (!HasMarker(result[0])) {
          // Set up the marker
          var latLong = new google.maps.LatLng(latt, lngt);
          var marker  = new google.maps.Marker({
            position: latLong,
            map: gMap,
            title: result[1],
            icon: 'img/pins/' + result[4] + 's.png', // Choses icon img by type
            size: new google.maps.Size(26, 32),
            visible: true,
            inc: {
              db: result[0],
              iName: result[1], iDetails: result[2],
              iCreated: result[4], iType: result[4],
              iVotes: (result[5] - result[6]),
            }
          });
          // Add listener for click
          var listen = marker.addListener('click', function() {
            
            var scrW = getWidth();
            gMap.setCenter(marker.getPosition());
            gMap.setZoom(14);
            if (scrW) {
              gMap.panBy(scrW * 0.2, 0);
            }
            
            // Retrieve call info and open info div
            $("#info-window").fadeIn(100);
            $("#info-title").html("LOADING INFORMATION");
            $("#info-title").html(this.inc.iName);
            $("#info-creator").html("(Coming Soon!)");
            $("#info-since").html("(Coming Soon!)");
            var divBody = $("#info-body").find("ul");
            divBody.empty();
            divBody.append(
              "<li>" + (this.inc.iDetails) + "</li>"
            );
            $("#info-vcount").html(this.inc.iVotes);
            $("#info-title").html(this.inc.iName);
            
          });
          marks.push([result[0], marker]); // Add to marker tracker by idIncident
          listn.push([result[0], listen]); // Corresponding listener
        
        }
      }
      
      
      /* LoadMarkers()
       * Loads current incident markers when map loads
       */
      function LoadMarkers() {
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
        setTimeout(LoadMarkers, 12000);
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
          //mapTypeId: 'terrain',
          scaleControl: true,
          streetViewControl: false,
          rotateControl: true,
          fullscreenControl: false
        });
        LoadMarkers();
      }