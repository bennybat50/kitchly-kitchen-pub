enum TimeChoice { all, day, hour, minutes, seconds, distance }

class GetTime {
  getCountDown({time, TimeChoice choice}) {
  
    // Get today's date and time
    
    var countDownDate;
    try{
     countDownDate = new DateTime(time).millisecondsSinceEpoch;
    }catch (e){
      print('Enter time error');
      countDownDate = new DateTime(0).millisecondsSinceEpoch;
    }
    var now = new DateTime.now().millisecondsSinceEpoch;
    // Find the distance between now and the count down date
    var distance = countDownDate - now;
    // Time calculations for days, hours, minutes and seconds
    var days, hours, minutes, seconds;
    days = distance / (1000 * 60 * 60 * 24);
    hours = (distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
    minutes = (distance % (1000 * 60 * 60)) / (1000 * 60);
    seconds = (distance % (1000 * 60)) / 1000;
    // if (distance < 0) {
    //   days = 0;
    //   hours = 0;
    //   minutes = 0;
    //   seconds = 0;
    // } else {
    //   days = distance / (1000 * 60 * 60 * 24);
    //   hours = (distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
    //   minutes = (distance % (1000 * 60 * 60)) / (1000 * 60);
    //   seconds = (distance % (1000 * 60)) / 1000;
    // }

    // Output the result in an element with id="demo"

    // If the count down is over, write some text

    switch (choice) {
      case TimeChoice.all:
        return "${days.round()}d ${hours.round()}h ${minutes.round()}m ${seconds.round()}s";
      case TimeChoice.day:
        return days.round();
      case TimeChoice.hour:
        return hours.round();
      case TimeChoice.minutes:
        return minutes.round();
      case TimeChoice.seconds:
        return seconds.round();
      case TimeChoice.distance:
        if (distance < 0) {
          return 0;
        } else {
          return distance;
        }
    }
    
  }
}
