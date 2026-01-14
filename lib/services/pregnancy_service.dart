import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/models/pregnancy_profile.dart';

class PregnancyService extends ChangeNotifier {
  static const _profilesKey = 'pregnancy_profiles';
  final Uuid _uuid = const Uuid();
  PregnancyProfile? _currentProfile;

  PregnancyProfile? get currentProfile => _currentProfile;

  Future<void> loadProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString(_profilesKey);
      if (profilesJson != null) {
        final profiles = (jsonDecode(profilesJson) as List)
            .map((e) => PregnancyProfile.fromJson(e))
            .toList();
        _currentProfile = profiles.firstWhere(
          (p) => p.userId == userId,
          orElse: () => throw Exception('Profile not found'),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load pregnancy profile: $e');
    }
  }

  Future<void> createProfile(String userId, DateTime dueDate, DateTime lastPeriodDate) async {
    try {
      final now = DateTime.now();
      final weeksDifference = now.difference(lastPeriodDate).inDays ~/ 7;
      
      final profile = PregnancyProfile(
        id: _uuid.v4(),
        userId: userId,
        dueDate: dueDate,
        lastPeriodDate: lastPeriodDate,
        currentWeek: weeksDifference,
        createdAt: now,
        updatedAt: now,
      );

      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString(_profilesKey);
      final profiles = profilesJson != null ? jsonDecode(profilesJson) as List : [];
      
      profiles.add(profile.toJson());
      await prefs.setString(_profilesKey, jsonEncode(profiles));
      
      _currentProfile = profile;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to create pregnancy profile: $e');
    }
  }

  Future<void> updateCurrentWeek() async {
    if (_currentProfile == null) return;

    try {
      final now = DateTime.now();
      final weeksDifference = now.difference(_currentProfile!.lastPeriodDate).inDays ~/ 7;
      
      final updatedProfile = _currentProfile!.copyWith(
        currentWeek: weeksDifference,
        updatedAt: now,
      );

      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString(_profilesKey);
      if (profilesJson != null) {
        final profiles = jsonDecode(profilesJson) as List;
        final index = profiles.indexWhere((p) => p['id'] == _currentProfile!.id);
        if (index != -1) {
          profiles[index] = updatedProfile.toJson();
          await prefs.setString(_profilesKey, jsonEncode(profiles));
        }
      }

      _currentProfile = updatedProfile;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to update current week: $e');
    }
  }
}