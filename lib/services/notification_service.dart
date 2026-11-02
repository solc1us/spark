import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/parking_session.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(settings: settings);
  }

  static Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final allowed = await android?.requestNotificationsPermission();
    return allowed ?? false;
  }

  static Future<bool> scheduleReminder(ParkingSession session) async {
    final minutes = session.reminderMinutes;
    if (minutes == null) return false;

    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));

    final reminderTime = tz.TZDateTime.from(
      session.createdAt,
      tz.local,
    ).add(Duration(minutes: minutes));

    if (!reminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
      return false;
    }

    await _plugin.zonedSchedule(
      id: session.id.hashCode,
      title: 'Pengingat parkir',
      body: 'Sudah parkir selama $minutes menit.',
      scheduledDate: reminderTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'parking_reminders',
          'Pengingat parkir',
          channelDescription: 'Pengingat durasi parkir.',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    return true;
  }

  static Future<bool> cancelReminder(String sessionId) async {
    try {
      await _plugin.cancel(id: sessionId.hashCode);
      return true;
    } catch (_) {
      return false;
    }
  }
}
