// ignore: file_names
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;

class PrayerTimeReminder {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool notificationsEnabled = true;

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'prayer_times',
      'Prayer Times',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleNotification(
      String prayerName, DateTime prayerTime) async {
    if (notificationsEnabled) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Prayer Time Reminder',
        'It\'s time for $prayerName prayer',
        tz.TZDateTime.from(prayerTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times',
            'Prayer Times',
          ),
        ),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> setPrayerTimeReminders() async {
    if (!notificationsEnabled) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // print(position.latitude);
    final response = await http.get(Uri.parse(
        'http://api.aladhan.com/v1/calendar?latitude=${position.latitude}&longitude=${position.longitude}&method=2'));
    List<dynamic> monthData = jsonDecode(response.body)['data'];

    for (Map<String, dynamic> dayData in monthData) {
      Map<String, dynamic> timings = dayData['timings'];

      for (String prayerName in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        String prayerTimeStr = timings[prayerName].split(' ')[0];
        DateTime prayerTime = DateTime.parse(
            '${DateTime.now().toIso8601String().split('T')[0]} $prayerTimeStr:00');
        await scheduleNotification(prayerName, prayerTime);
      }
    }
  }
}
