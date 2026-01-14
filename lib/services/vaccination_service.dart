import 'package:flutter/foundation.dart';

class VaccinationService extends ChangeNotifier {
	List records = <dynamic>[];

	Future<void> initialize() async {}
	Future<void> loadRecords(String childId) async {}
}

