import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/models/milestone.dart';

class MilestoneService extends ChangeNotifier {
  static const _milestonesKey = 'milestones';
  final Uuid _uuid = const Uuid();
  List<Milestone> _milestones = [];
  bool _isInitialized = false;

  List<Milestone> get milestones => _milestones;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final milestonesJson = prefs.getString(_milestonesKey);
      
      if (milestonesJson != null) {
        _milestones = (jsonDecode(milestonesJson) as List)
            .map((e) => Milestone.fromJson(e))
            .toList();
      } else {
        await _initializeSampleData(prefs);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize milestones: $e');
    }
  }

  Future<void> _initializeSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _milestones = [
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 0,
        title: 'First Smile',
        description: 'Social smile begins to appear',
        icon: '😊',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 2,
        title: 'Holds Head Up',
        description: 'Can hold head up during tummy time',
        icon: '👶',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 4,
        title: 'Laughs and Babbles',
        description: 'Starts making cooing sounds and laughing',
        icon: '🗣️',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 6,
        title: 'Sits Without Support',
        description: 'Can sit independently for short periods',
        icon: '🪑',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 9,
        title: 'Crawling',
        description: 'Begins to crawl or scoot around',
        icon: '🚼',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 12,
        title: 'First Steps',
        description: 'Takes first independent steps',
        icon: '👣',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 15,
        title: 'First Words',
        description: 'Says meaningful words like "mama" or "dada"',
        icon: '💬',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 18,
        title: 'Walking Steadily',
        description: 'Walks without falling frequently',
        icon: '🚶',
        createdAt: now,
        updatedAt: now,
      ),
      Milestone(
        id: _uuid.v4(),
        type: 'child',
        weekOrMonth: 24,
        title: 'Two-Word Phrases',
        description: 'Combines two words to communicate',
        icon: '🗨️',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await prefs.setString(
      _milestonesKey,
      jsonEncode(_milestones.map((e) => e.toJson()).toList()),
    );
  }

  List<Milestone> getMilestonesByType(String type) =>
      _milestones.where((m) => m.type == type).toList();

  List<Milestone> getMilestonesByAge(int ageInMonths) =>
      _milestones.where((m) => m.weekOrMonth <= ageInMonths && m.type == 'child').toList();
}
