
      var marks = []; // Keeps tracks of markers {0:idIncident, 1:Object}
      var listn = []; // List of listeners {0:idIncident, 1:Object}
      var gMap;
      var markTime = null;
      
      
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
      
      
      /* TimeDifference()
       * Returns the time in a readable string of the elapsed time
       * @param incTime The time the incident was created, in Epoch
       * @returns String
       */
      function TimeDifference(incTime) {
        
        var fromDate = parseInt(new Date(incTime).getTime()/1000); 
        var toDate   = parseInt(new Date($.now()).getTime()/1000);
        var s        = (toDate - fromDate);
        
        // 172800 = 2 Days / 48 Hours
        if (s < 60) {
          if (s == 1) return ("1 second");
          return (s + " seconds");
        }
        else if (s < 3600) {
          if (s < 120) return ("1 minute");
          return (Math.floor(s/60) + " minutes");
        }
        else if (s < 172800) {
          if (s < 7200) return ("1 hour");
          return (Math.floor(s/3600) + "hours");
        }
        else {
          return (Math.floor(s) + " days");
        }
        return "na"
      }
      
      /* Call an interval/timeout on this while div is open */
      function UpdateMarkerTime(mapMarker) {
        $("#info-since").html((TimeDifference(mapMarker.inc.iCreated) + " ago"));
        //if ( !(("#info-window").is(':visible')) ) {clearInterval(markTime);}
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
            title: result[3],
            icon: 'img/pins/' + result[6] + 's.png', // Choses icon img by type
            size: new google.maps.Size(26, 32),
            visible: true,
            inc: {
              db: result[0],
              iName: result[3], iDetails: result[5],
              iCreated: result[4], iType: result[6],
              iVotes: (result[7] - result[8]),
              iMaker: result[9]
            }
          });
          
          // Add listener for click
          var listen = marker.addListener('click', function() {
            
            var scrW = getWidth();
            
            // Center the View
            gMap.setCenter(marker.getPosition());
            gMap.setZoom(14);
            if (scrW) { gMap.panBy(scrW * 0.145, 0); }
            
            // Retrieve call info and open info div
            $("#info-window").fadeIn(100);
            $("#info-title").html("LOADING INFORMATION");
            $("#info-title").html(this.inc.iName);
            $("#info-creator").html(this.inc.iMaker);
            UpdateMarkerTime(this);
            var divBody = $("#info-body").find("ul");
            divBody.empty();
            var str = this.inc.iDetails.replace(/(?:\r\n|\r|\n)/g, '</li><li>');
            divBody.append(
              "<li>" + (this.inc.iDetails) + "</li>"
            );
            $("#info-vcount").html(this.inc.iVotes);
            $("#info-title").html(this.inc.iName);
            
            //var markTime = setInterval(UpdateMarkerTime, 1000, this);
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
          url: "../php/incidents.php",
          success: function(result) {
            var jsn    = JSON.parse(result);
            var idList = [];
            for (var i = 0; i < jsn.length; i++) {
              
              // Go through and create a marker for each result from SQL
              CreateMarker(Number(jsn[i][2]), Number(jsn[i][1]), jsn[i]);
              
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
        
        // Creates the Google Map 'gMap'
        gMap = new google.maps.Map(document.getElementById('gmap'), {
          center: {lat: 37.0902, lng: -95.7129},
          zoom: 5,
          zoomControl: true,
          mapTypeControl: false,
          //mapTypeId: 'terrain',
          scaleControl: true,
          streetViewControl: false,
          rotateControl: true,
          fullscreenControl: false,
          styles: [
            {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
            {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
            {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
            {
              featureType: 'administrative.locality',
              elementType: 'labels.text.fill',
              stylers: [{color: '#d59563'}]
            },
            {
              featureType: 'poi',
              elementType: 'labels.text.fill',
              stylers: [{color: '#d59563'}]
            },
            {
              featureType: 'poi.park',
              elementType: 'geometry',
              stylers: [{color: '#263c3f'}]
            },
            {
              featureType: 'poi.park',
              elementType: 'labels.text.fill',
              stylers: [{color: '#6b9a76'}]
            },
            {
              featureType: 'road',
              elementType: 'geometry',
              stylers: [{color: '#38414e'}]
            },
            {
              featureType: 'road',
              elementType: 'geometry.stroke',
              stylers: [{color: '#212a37'}]
            },
            {
              featureType: 'road',
              elementType: 'labels.text.fill',
              stylers: [{color: '#9ca5b3'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'geometry',
              stylers: [{color: '#746855'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'geometry.stroke',
              stylers: [{color: '#1f2835'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'labels.text.fill',
              stylers: [{color: '#f3d19c'}]
            },
            {
              featureType: 'transit',
              elementType: 'geometry',
              stylers: [{color: '#2f3948'}]
            },
            {
              featureType: 'transit.station',
              elementType: 'labels.text.fill',
              stylers: [{color: '#d59563'}]
            },
            {
              featureType: 'water',
              elementType: 'geometry',
              stylers: [{color: '#17263c'}]
            },
            {
              featureType: 'water',
              elementType: 'labels.text.fill',
              stylers: [{color: '#515c6d'}]
            },
            {
              featureType: 'water',
              elementType: 'labels.text.stroke',
              stylers: [{color: '#17263c'}]
            }
          ]
        });
        
        
        // Adds a listener to close the info-window
        gMap.addListener('click', function() {
          $("#info-window").hide();
        });
        
        // Creates applicable markers
        LoadMarkers();
        getLocation(); // DEBUG
        
      } // End function initMap()
      
      // DEBUG - Stuff
      function getLocation() {
        if (navigator.geolocation) {
          console.log('Requesting users location');
          navigator.geolocation.getCurrentPosition(showPosition);
        } else {
          console.log('GeoLocation not supported.');
          alert("Geolocation is not supported by this browser.");
        }
      }
      function showPosition(position) {
        var lat = position.coords.latitude;
        var lng = position.coords.longitude;
        console.log('Moving based on location!');
        
        // Moves map to the user's current location
        gMap.setCenter(new google.maps.LatLng(lat, lng));
        gMap.setZoom(12);
        
      }