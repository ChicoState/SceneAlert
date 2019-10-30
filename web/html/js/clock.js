
      const nth = function(d) {
        if (d > 3 && d < 21) return 'th';
        switch (d % 10) {
          case 1:  return "st";
          case 2:  return "nd";
          case 3:  return "rd";
          default: return "th";
        }
      }
      // Update #display-dtime with current date and time
      function ClockUpdate() {
        var now = new Date(),
          months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'];
            
        var mid ='AM';
        var hours = now.getHours() 
        if (hours == 0) {hours=12;} // Consider midnight being AM
        else if (hours > 12) {
          hours = hours % 12;
          mid   = 'PM';
        }
        
        var time = (
          hours + ':' + ("0" + now.getMinutes()).slice(-2) + ' ' + mid
        );
        var today = now.getDate()
        var date =
            months[now.getMonth()] +
            ' ' + today + nth(today) + ', ' +
            now.getFullYear()
        
        // Update DIV
        document.getElementById('display-time').innerHTML = time;
        document.getElementById('display-date').innerHTML = date;
        //console.log(date + ' ' + time);
        
        // Repeat every 1.0 seconds
        setTimeout(ClockUpdate, 5000);
      }
      ClockUpdate();