import 'package:flutter/foundation.dart';

class AppointmentService extends ChangeNotifier {
	List getUpcoming() => <dynamic>[];
	List getPast() => <dynamic>[];

	Future<void> addAppointment(dynamic appointment) async {}
	Future<void> updateAppointment(dynamic appointment) async {}
	Future<void> loadAppointments(String userId) async {}
}

