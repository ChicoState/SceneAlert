<?php
?>
    <div id="call-control">
    
      <h3>Control Panel</h3>
      
      <!-- Controls to Search / View -->
      <div id="call-search">
        <table>
          <tr>
            <th colspan="2">Search for Address</th>
          </tr>
          <tr>
            <td width="70%">
              <input type="text" id="sr-addr" name="sr-addr" placeholder="123 Easy Street">
            </td>
            <td width="30%">
              <button onclick="SearchAddress()">Search</button>
            </td>
          </th>
        </table>
      </div>
      
      <!-- Controls to create a call or edit existing -->
      <div id="call-create">
        <h3>New Incident</h3>
        <p><button onclick="NewCallHelp()">Help</button>
        <table>
          <tr>
            <td>Address</td>
            <td><input type="text" id="new-stnumber" name="new-stnumber" placeholder="123" autocomplete="off"/></td>
            <td><input type="text" id="new-stname" name="new-stname" placeholder="Easy Street" autocomplete="off"/></td>
          </tr>
          <tr>
            <td><input type="number" id="new-zip" name="new-zip" placeholder="90210 (opt)" autocomplete="off"/></td>
            <td><input type="text" id="new-city" name="new-city" placeholder="City Name (opt)" autocomplete="off"/></td>
            <td><input type="text" id="new-state" name="new-state" placeholder="CA" maxlength="2" autocomplete="off"/></td>
          </tr>
          <tr>
            <td>Situation</td>
            <td colspan="2">
              <div id="call-select">
              <select name="new-type" id="new-type" autocomplete="off">
                <option value="1" selected="selected">Police Activity</option>
                <option value="2">Fire / Rescue</option>
                <option value="3">Medical Emergency</option>
                <option value="4">Multi-Agency</option>
                <option value="5">Military Operation</option>
                <option value="6">System Admin / Testing</option>
              </select>
              </div>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <input type="text" id="new-title" name="new-title" placeholder="Brief Title of Event" autocomplete="off"/>
            </td>
          </tr>
          <tr>
            <td colspan="3">
              <textarea autocomplete="off" id="new-details" name="new-details"></textarea>
            </td>
          </tr>
          <tr>
            <td colspan="3"><button onclick="NewCallCreate(
            <?php echo $_SESSION['user'];?>
              )">Submit</button>
          </tr>
        </table>
      </div>
      
    </div>