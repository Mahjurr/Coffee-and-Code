
import 'dart:core';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notificaitions = FlutterLocalNotificationsPlugin();
  static final onNotificaitons = BehaviorSubject<String?>();


  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notificaitions.show(
        id,
        title,
        body,
        await _notificaitionDetails(),
        payload: payload,
      );

  static Future init({bool initScheduled = false}) async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(
        android: initializationSettingsAndroid);

    await _notificaitions.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotificaitons.add(payload);
      },
    );
    if (initScheduled) {
      tz.initializeTimeZones();
     final locationName = await FlutterNativeTimezone.getLocalTimezone();
     tz.setLocalLocation(tz.getLocation(locationName));
    }
    final details = await _notificaitions.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
        onNotificaitons.add(details.payload);
    }
  }


  static Future _notificaitionDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'channel description',
            icon:"@ic_launcher",
            importance: Importance.max

        )
    );
  }

  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notificaitions.zonedSchedule(
        id,
        title,
        body,
        //tz.TZDateTime.from(scheduledDate, tz.local),
        _scheduleDaily(Time(8, 30)),//8:30
        await _notificaitionDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,

      );
  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days:1))
        : scheduledDate;
  }
}
