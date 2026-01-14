import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_application_1/models/appointment.dart';
// child_profile and vaccination model imports removed — using dynamic to remain resilient during analysis

/// NotificationService handles local (on-device) scheduled notifications
/// for appointments and vaccination reminders.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'reminders_channel';
  static const _channelName = 'Reminders';
  static const _channelDescription = 'Appointment and vaccination reminders';

  Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      debugPrint('Notifications disabled on web in this build. Skipping init.');
      _initialized = true;
      return;
    }

    try {
      // Initialize timezones for precise scheduling
      try {
        tzdata.initializeTimeZones();
        final String localTz = (await FlutterTimezone.getLocalTimezone()).toString();
        tz.setLocalLocation(tz.getLocation(localTz));
      } catch (e) {
        debugPrint('Failed to initialize timezone data: $e');
        // Fallback to UTC if local timezone fails
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

      await _plugin.initialize(initSettings);

      // Create Android channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      );
      await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      await _requestPermissions();
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService init failed: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Android 13+ runtime permission
      await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Android notifications permission request failed: $e');
    }

    try {
      // iOS permissions
      await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('iOS notifications permission request failed: $e');
    }
  }

  // Helpers to generate unique IDs
  int _aptId(String appointmentId) => appointmentId.hashCode & 0x7fffffff;
  int _vacId(String childId, String vaccinationId) => ('${childId}_$vaccinationId').hashCode & 0x7fffffff;

  NotificationDetails _details() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    return const NotificationDetails(android: android, iOS: ios);
  }

  tz.TZDateTime _toTz(DateTime when) => tz.TZDateTime.from(when, tz.local);

  Future<void> scheduleAppointmentReminder(Appointment apt, {Duration leadTime = const Duration(hours: 2)}) async {
    if (!_initialized || kIsWeb) return;
    if (apt.isCompleted) return;
    try {
      final scheduled = apt.dateTime.subtract(leadTime);
      if (scheduled.isBefore(DateTime.now())) return; // Don't schedule past reminders
      await _plugin.zonedSchedule(
        _aptId(apt.id),
        'Upcoming appointment: ${apt.title}',
        _formatAptBody(apt),
        _toTz(scheduled),
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Failed to schedule appointment reminder: $e');
    }
  }

  Future<void> cancelAppointmentReminder(String appointmentId) async {
    if (!_initialized || kIsWeb) return;
    try {
      await _plugin.cancel(_aptId(appointmentId));
    } catch (e) {
      debugPrint('Failed to cancel appointment reminder: $e');
    }
  }

  String _formatAptBody(Appointment apt) {
    final when = '${apt.dateTime.year}-${apt.dateTime.month.toString().padLeft(2, '0')}-${apt.dateTime.day.toString().padLeft(2, '0')} ${apt.dateTime.hour.toString().padLeft(2, '0')}:${apt.dateTime.minute.toString().padLeft(2, '0')}';
    final loc = apt.location != null && apt.location!.isNotEmpty ? ' • ${apt.location}' : '';
    return '$when$loc';
  }

  Future<void> scheduleVaccinationReminder(dynamic child, dynamic v, {Duration leadTime = const Duration(days: 3)}) async {
    if (!_initialized || kIsWeb) return;
    try {
  // Calculate due date based on child's birth date and vaccination age (in months).
  final int daysUntil = (v.ageInMonths is num) ? ((v.ageInMonths as num) * 30).round() : 0;
  final dueDate = child.birthDate.add(Duration(days: daysUntil));
  final scheduled = dueDate.subtract(leadTime);
      if (scheduled.isBefore(DateTime.now())) return; // Skip past reminders
      await _plugin.zonedSchedule(
        _vacId(child.id, v.id),
        'Vaccination due soon: ${v.name}',
        'Recommended at ${v.ageInMonths} months for ${child.name}',
        _toTz(scheduled),
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Failed to schedule vaccination reminder: $e');
    }
  }

  Future<void> cancelVaccinationReminder(String childId, String vaccinationId) async {
    if (!_initialized || kIsWeb) return;
    try {
      await _plugin.cancel(_vacId(childId, vaccinationId));
    } catch (e) {
      debugPrint('Failed to cancel vaccination reminder: $e');
    }
  }

  /// Schedules reminders for a list of upcoming appointments.
  Future<void> scheduleUpcomingAppointments(Iterable<Appointment> appointments) async {
    for (final a in appointments) {
      // Cancel old (prevents duplicates) then schedule
      await cancelAppointmentReminder(a.id);
      await scheduleAppointmentReminder(a);
    }
  }

  /// Schedules reminders for all not-yet-due vaccinations for the child.
  Future<void> scheduleUpcomingVaccinationsForChild({required dynamic child, required List vaccinations, required bool Function(String vaccinationId) isComplete}) async {
    for (final v in vaccinations) {
      final id = (v is Map) ? v['id'] : (v?.id);
      if (id != null && isComplete(id)) {
        await cancelVaccinationReminder(child.id, id);
        continue;
      }
      if (id != null) await cancelVaccinationReminder(child.id, id);
      await scheduleVaccinationReminder(child, v);
    }
  }
}
