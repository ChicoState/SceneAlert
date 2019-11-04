<?php
  ?>
    <div id="legend">
      <table>
          <tr>
            <th><img src="img/pins/1s.png" width="16px" height="24px"/></th>
            <td>Law Enforcement</td>
            <th><img src="img/pins/2s.png" width="16px" height="24px"/></th>
            <td>Fire / Rescue</td>
            <th><img src="img/pins/3s.png" width="16px" height="24px"/></th>
            <td>Medical</td>
          </tr>
          <tr>
            <th><img src="img/pins/4s.png" width="16px" height="24px"/></th>
            <td>Multi-Service</td>
            <th><img src="img/pins/5s.png" width="16px" height="24px"/></th>
            <td>Military</td>
            <th><img src="img/pins/6s.png" width="16px" height="24px"/></th>
            <td>System Admin</td>
          </tr>
          <tr>
            <th><img src="img/info/alert.png" width="24px" height="24px"/></th>
            <td>Report Issue</td>
            <th><img src="img/info/msg.png" width="24px" height="24px"/></th>
            <td>Send Message</td>
            <th><img src="img/info/view.png" width="24px" height="24px"/></th>
            <td>View Details</td>
          </tr>
          <tr>
            <td colspan="2"><button onclick="ToggleLegend()">HIDE</button></td>
          </tr>
      </table>
    </div>
    <div id="legshow" style="display: none;">
      <button onclick="ToggleLegend()">LEGEND</button>
    </div>
  <?php
?>