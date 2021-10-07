import 'dart:developer';
import 'dart:io' show Platform;
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarServices {
  static const _scopes = const [CalendarApi.CalendarScope];

  insert(title, startTime, endTime) {
    var _clientID;
    if (Platform.isAndroid){
      _clientID = new ClientId("867962858531-pl8u3gea729pnks8h0pnffh18ffm0kj6.apps.googleusercontent.com", "");
    }
    else if (Platform.isIOS){
      _clientID = new ClientId("867962858531-r8br198qb7o1bqak7manbd9danpfl5ab.apps.googleusercontent.com", "");
    }
    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);

      calendar.calendarList.list().then((value) => print("VAL________$value"));

      String calendarId = "primary";
      Event event = Event(); // Create object of event

      event.summary = title;

      EventDateTime start = new EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+05:30";
      event.start = start;

      EventDateTime end = new EventDateTime();
      end.timeZone = "GMT+05:30";
      end.dateTime = DateTime.parse(endTime);
      event.end = end;
      try {
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDED_________________${value.status}");
          if (value.status == "confirmed") {
            //log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      } catch (e) {
        log('Error creating event $e');
      }
    });
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}