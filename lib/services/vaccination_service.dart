import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/models/vaccination.dart';
import 'package:flutter_application_1/models/vaccination_record.dart';
import 'package:flutter_application_1/services/notification_service.dart';

class VaccinationService extends ChangeNotifier {
  static const _vaccinationsKey = 'vaccinations';
  static const _recordsKey = 'vaccination_records';
  final Uuid _uuid = const Uuid();
  List<Vaccination> _vaccinations = [];
  List<VaccinationRecord> _records = [];
  bool _isInitialized = false;

  List<Vaccination> get vaccinations => _vaccinations;
  List<VaccinationRecord> get records => _records;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final vaccinationsJson = prefs.getString(_vaccinationsKey);
      
      if (vaccinationsJson != null) {
        _vaccinations = (jsonDecode(vaccinationsJson) as List)
            .map((e) => Vaccination.fromJson(e))
            .toList();
      } else {
        await _initializeSampleData(prefs);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize vaccinations: $e');
    }
  }

  Future<void> _initializeSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _vaccinations = [
      Vaccination(
        id: _uuid.v4(),
        name: 'Hepatitis B',
        ageInMonths: 0,
        description: 'First dose at birth',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'DTaP',
        ageInMonths: 2,
        description: 'Diphtheria, Tetanus, and Pertussis vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Polio (IPV)',
        ageInMonths: 2,
        description: 'Inactivated Poliovirus vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Hib',
        ageInMonths: 2,
        description: 'Haemophilus influenzae type b vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Pneumococcal',
        ageInMonths: 2,
        description: 'Protects against pneumococcal disease',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Rotavirus',
        ageInMonths: 2,
        description: 'Protects against rotavirus infection',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'DTaP (2nd dose)',
        ageInMonths: 4,
        description: 'Second dose of DTaP vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'MMR',
        ageInMonths: 12,
        description: 'Measles, Mumps, and Rubella vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Varicella',
        ageInMonths: 12,
        description: 'Chickenpox vaccine',
        createdAt: now,
        updatedAt: now,
      ),
      Vaccination(
        id: _uuid.v4(),
        name: 'Hepatitis A',
        ageInMonths: 12,
        description: 'First dose of Hepatitis A vaccine',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await prefs.setString(
      _vaccinationsKey,
      jsonEncode(_vaccinations.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> loadRecords(String childId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getString(_recordsKey);
      
      if (recordsJson != null) {
        final allRecords = (jsonDecode(recordsJson) as List)
            .map((e) => VaccinationRecord.fromJson(e))
            .toList();
        _records = allRecords.where((r) => r.childId == childId).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load vaccination records: $e');
    }
  }

  Future<void> addRecord(VaccinationRecord record) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = prefs.getString(_recordsKey);
      final allRecords = recordsJson != null 
          ? jsonDecode(recordsJson) as List 
          : [];
      
      allRecords.add(record.toJson());
      await prefs.setString(_recordsKey, jsonEncode(allRecords));
      
      _records.add(record);
      notifyListeners();
      // Cancel any scheduled reminder for this vaccination for the child
      await NotificationService.instance.cancelVaccinationReminder(record.childId, record.vaccinationId);
    } catch (e) {
      debugPrint('Failed to add vaccination record: $e');
    }
  }

  bool isVaccinationComplete(String vaccinationId, String childId) =>
      _records.any((r) => r.vaccinationId == vaccinationId && r.childId == childId);

  List<Vaccination> getDueVaccinations(int childAgeInMonths) =>
      _vaccinations.where((v) => v.ageInMonths <= childAgeInMonths).toList();

  List<Vaccination> getUpcomingVaccinations(int childAgeInMonths) =>
      _vaccinations.where((v) => v.ageInMonths > childAgeInMonths).toList();
}
