<?php
  include('../inc/database.php');
  
  $retarray = array(); // For the end
  
  // Assign handlers for easy recall
  $cInfo = array(
    "num"    => (!empty($_POST['aNumber'])   ? $_POST['aNumber']   : null),
    "street" => (!empty($_POST['aStreet'])   ? $_POST['aStreet']   : null),
    "zip"    => (!empty($_POST['aZip'])      ? $_POST['aZip']      : null),
    "city"   => (!empty($_POST['aCity'])     ? $_POST['aCity']     : null),
    "state"  => (!empty($_POST['aState'])    ? $_POST['aState']    : null),
    "long"   => (!empty($_POST['longitude']) ? $_POST['longitude'] : null),
    "latt"   => (!empty($_POST['latitude'])  ? $_POST['latitude']  : null),
  );
  
  $likeSearch = array(
    "street" => '%'.$cInfo['street'].'%',
    "city"   => '%'.$cInfo['city'].'%'
  );
  
  $useAddress = isset($cInfo['num'])  && isset($cInfo['street']);
  $useCoords  = isset($cInfo['long']) && isset($cInfo['latt']);
  $useZip     = isset($cInfo['zip']);
  $useCity    = isset($cInfo['city']) && isset($cInfo['state']);
  
  $stNames = array(
    'AL'=>'ALABAMA',	'AK'=>'ALASKA',	'AS'=>'AMERICAN SAMOA',
    'AZ'=>'ARIZONA',	'AR'=>'ARKANSAS',	'CA'=>'CALIFORNIA',
    'CO'=>'COLORADO',	'CT'=>'CONNECTICUT',	'DE'=>'DELAWARE',
    'DC'=>'DISTRICT OF COLUMBIA',	'FM'=>'FEDERATED STATES OF MICRONESIA',
    'FL'=>'FLORIDA',	'GA'=>'GEORGIA',	'GU'=>'GUAM GU',
    'HI'=>'HAWAII',	'ID'=>'IDAHO',	'IL'=>'ILLINOIS',
    'IN'=>'INDIANA',	'IA'=>'IOWA',	'KS'=>'KANSAS',	'KY'=>'KENTUCKY',
    'LA'=>'LOUISIANA',	'ME'=>'MAINE',	'MH'=>'MARSHALL ISLANDS',
    'MD'=>'MARYLAND',	'MA'=>'MASSACHUSETTS',	'MI'=>'MICHIGAN',
    'MN'=>'MINNESOTA',	'MS'=>'MISSISSIPPI',	'MO'=>'MISSOURI',
    'MT'=>'MONTANA',	'NE'=>'NEBRASKA',	'NV'=>'NEVADA',
    'NH'=>'NEW HAMPSHIRE',	'NJ'=>'NEW JERSEY',	'NM'=>'NEW MEXICO',
    'NY'=>'NEW YORK',	'NC'=>'NORTH CAROLINA',	'ND'=>'NORTH DAKOTA',
    'MP'=>'NORTHERN MARIANA ISLANDS',	'OH'=>'OHIO',	'OK'=>'OKLAHOMA',
    'OR'=>'OREGON',	'PW'=>'PALAU',	'PA'=>'PENNSYLVANIA',
    'PR'=>'PUERTO RICO',	'RI'=>'RHODE ISLAND',	'SC'=>'SOUTH CAROLINA',
    'SD'=>'SOUTH DAKOTA',	'TN'=>'TENNESSEE',	'TX'=>'TEXAS',
    'UT'=>'UTAH',	'VT'=>'VERMONT',	'VI'=>'VIRGIN ISLANDS',
    'VA'=>'VIRGINIA',	'WA'=>'WASHINGTON',	'WV'=>'WEST VIRGINIA',
    'WI'=>'WISCONSIN',	'WY'=>'WYOMING',
    'AE'=>'ARMED FORCES AFRICA \ CANADA \ EUROPE \ MIDDLE EAST',
    'AA'=>'ARMED FORCES AMERICA (EXCEPT CANADA)',
    'AP'=>'ARMED FORCES PACIFIC'
  );
  
  // Address with Zip or City/State, OR Coordinates
  if (($useAddress and ($useZip or $useCity)) or $useCoords) {
    
    $qryString = "SELECT idLocation FROM locations ";
    $locn;
    
    /* Use Street Address
     * We prefer this, because one location may have multiple coordinates.
     *
     * There's identical addresses all over the United States.
     * So, to alleviate this issue, we MUST search by city/state or zip code.
     */
    if ($useAddress) {
      
      // Search by Zipcode (easy and straight forward, zip codes are unique)
      if ($useZip) {
        
        $locn = $db->prepare($qryString . "
          WHERE house_number = ?
          AND street LIKE ? 
          AND zipcode = ?
        ");
        $locn->bindParam(1, $cInfo['num']);
        $locn->bindParam(2, $likeSearch['street']);
        $locn->bindParam(3, $cInfo['zip']);
        
      // Search by City/State (not so easy)
      } else {
        
        // Retrieve idState
        $getState = $db->prepare("
          SELECT idState FROM states WHERE name LIKE `%:st`
        ");
        $getState->bindParam(':st', $stNames[$cInfo[4]]);
        
        if ($getState->execute()) {
          
          // Retrieve idCity ONLY AFTER identifying the State
          // There's a chance a state may have two cities of the same name
          // In that case...... Tough luck. Should have used Zip Code.
          $getCity = $db->prepare("
            SELECT idCity FROM cities
            WHERE name LIKE `%:city%` AND idState = :st
            LIMIT 1
          ");
          $getCity->bindParam(':city', $cInfo[3]);
          $getCity->bindParam(':st', $getState->fetchColumn());
          
          if($getCity->execute()) {
            $locn = $db->prepare($qryString . "
              WHERE idState = :st AND idCity = :city
            ");
            $locn->bindparam(':st',   $getState->fetchColumn());
            $locn->bindparam(':city', $getCity->fetchColumn());
          
          // No city was found
          // DEBUG - This SHOULD insert the city, but we'll come back to it
          } else {
            $retarray[0] = (-1);
            $retarray[1] = "SQL Query Failed: SELECT idCity";
          }
          
        // No state was found
        // DEBUG - This SHOULD insert the state, but we'll come back to it
        } else {
          $retarray[0] = (-1);
          $retarray[1] = "SQL Query Failed: SELECT idState";
        }
        
      }
      
    // Use coordinates (Requires more precision, most likely won't be found)
    } else {
      
      // DEBUG - To be added
      // Before we make a Google API request,
      // make sure we don't have a nearby address that we can use first
      
      $locn = $db->prepare($qryString . "
        WHERE longitude = :long AND latitude = :latt
      ");
      $locn->bindParam(':long', $cInfo[5]);
      $locn->bindParam(':latt', $cInfo[6]);
      
    }
    
    if($locn->execute()) {
      $idLoc = $locn->fetchColumn();
      
      // idLocation exists in the SQL Database! USE IT!!
      if ($idLoc) {
        $retarray[0] = 1;
        $retarray[1] = $idLoc;
      } else {
        /*
        // Lovely... Now we have to pay for a Google Maps API Geolocation
        $retarray[0] = 0;
        $retarray[1] = "Location not found, we will have to use GeoLocation.";
        */
        $srch = $cInfo['num'] . " " . $cInfo['street'];
        if ($useZip) {
          $srch = $srch . " " . $cInfo['zip'];
        } else {
          $srch = $srch . " " . $cInfo['city'] . " " . $cInfo['state'];
        }
        $retarray[0] = 0;
        $retarray[1] = $srch;
      }
      
    } else {
      $retarray[0] = (-1);
      $retarray[1] = "SQL Failed: " . $db->errorInfo()[1];
    }
    
  } else {
    $retarray[0] = (0);
    $retarray[1] = "A Full Address & Zip Code /OR/ Longitude & Latitude Required";
    
  }
  echo json_encode($retarray);
  $db = null;
  exit();
  
?>