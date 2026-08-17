import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // requestAlertPermission: false — onboarding owns the first-time system prompt.
    // We only initialise here; the user explicitly grants permission on page 2 of onboarding.
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(settings: initializationSettings);

    // NOTE: We intentionally do NOT call requestNotificationsPermission() here.
    // The onboarding screen is the single, intentional first-ask for permissions.
  }

  /// Checks whether notifications are currently enabled on this device.
  /// Returns false if the platform implementation is unavailable.
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImpl?.areNotificationsEnabled() ?? false;
    } else if (Platform.isIOS) {
      final iosImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      // requestPermissions with no-op booleans acts as a status check on iOS.
      // If permissions were already granted, returns true; denied returns false.
      return await iosImpl?.requestPermissions(alert: false, badge: false, sound: false) ?? false;
    }
    return false;
  }

  /// Requests notification permission from the OS.
  /// Returns true if the user granted permission.
  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImpl?.requestNotificationsPermission() ?? false;
    } else if (Platform.isIOS) {
      final iosImpl = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iosImpl?.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  static Future<void> scheduleRoutineReminder(
      int routineId, String routineName, int hour, int minute) async {
    // Cancel previous
    await _notificationsPlugin.cancel(id: routineId);

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'Ila_routine_channel',
      'Routine Reminders',
      channelDescription: 'Neutral daily reminders for your routines',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id: routineId,
      title: 'Imyra',
      body: 'Time for your $routineName routine.',
      scheduledDate: scheduledDate,
      notificationDetails: platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
