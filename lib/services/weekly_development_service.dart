import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/models/weekly_development.dart';

class WeeklyDevelopmentService extends ChangeNotifier {
  static const _developmentsKey = 'weekly_developments';
  final Uuid _uuid = const Uuid();
  List<WeeklyDevelopment> _developments = [];
  bool _isInitialized = false;

  List<WeeklyDevelopment> get developments => _developments;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final developmentsJson = prefs.getString(_developmentsKey);
      
      if (developmentsJson != null) {
        _developments = (jsonDecode(developmentsJson) as List)
            .map((e) => WeeklyDevelopment.fromJson(e))
            .toList();
      } else {
        await _initializeSampleData(prefs);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize weekly developments: $e');
    }
  }

  Future<void> _initializeSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _developments = [
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 8,
        title: 'Size of a Raspberry',
        description: 'Your baby is about the size of a raspberry. All major organs have begun to form, and the baby is starting to move, though you cannot feel it yet.',
        sizeComparison: '🫐 Raspberry (1.6 cm)',
        motherChanges: 'You may experience morning sickness, fatigue, and breast tenderness. Mood swings are common.',
        tips: ['Stay hydrated', 'Eat small, frequent meals', 'Get plenty of rest'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 12,
        title: 'Size of a Lime',
        description: 'Baby is the size of a lime now. Vocal cords are forming, and reflexes are developing. The baby can open and close fingers.',
        sizeComparison: '🍋 Lime (5.4 cm)',
        motherChanges: 'Morning sickness may start to ease. Your uterus is growing and may be felt above the pubic bone.',
        tips: ['Continue prenatal vitamins', 'Start gentle exercises', 'Schedule your first ultrasound'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 16,
        title: 'Size of an Avocado',
        description: 'Baby is about the size of an avocado. Facial muscles are developing, and baby can make expressions. The nervous system is functioning.',
        sizeComparison: '🥑 Avocado (11.6 cm)',
        motherChanges: 'Your baby bump is becoming more noticeable. You may feel more energetic as the second trimester begins.',
        tips: ['Stay active with prenatal yoga', 'Start thinking about maternity clothes', 'Connect with other expecting parents'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 20,
        title: 'Size of a Banana',
        description: 'Halfway there! Baby is the size of a banana. You may feel baby\'s movements now. Baby can hear sounds and may respond to your voice.',
        sizeComparison: '🍌 Banana (25.6 cm)',
        motherChanges: 'You can feel baby\'s movements! Your belly is growing, and you may experience back pain.',
        tips: ['Talk and sing to your baby', 'Schedule anatomy scan', 'Practice good posture'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 24,
        title: 'Size of a Cantaloupe',
        description: 'Baby is about the size of a cantaloupe. Lungs are developing, and baby practices breathing movements. Brain development is rapid.',
        sizeComparison: '🍈 Cantaloupe (30 cm)',
        motherChanges: 'Your belly is growing rapidly. You may experience Braxton Hicks contractions.',
        tips: ['Monitor blood sugar levels', 'Stay cool and comfortable', 'Practice relaxation techniques'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 28,
        title: 'Size of an Eggplant',
        description: 'Baby is the size of an eggplant. Eyes can open and close, and baby can blink. Baby may be able to dream during REM sleep.',
        sizeComparison: '🍆 Eggplant (37.6 cm)',
        motherChanges: 'Third trimester begins! You may feel more tired and experience shortness of breath.',
        tips: ['Start preparing nursery', 'Consider childbirth classes', 'Monitor baby\'s movements'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 32,
        title: 'Size of a Coconut',
        description: 'Baby is about the size of a coconut. Baby is gaining weight rapidly and developing a sleep-wake cycle.',
        sizeComparison: '🥥 Coconut (42.4 cm)',
        motherChanges: 'You may experience swelling in your feet and ankles. Frequent urination is common.',
        tips: ['Pack your hospital bag', 'Finalize birth plan', 'Rest as much as possible'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 36,
        title: 'Size of a Papaya',
        description: 'Baby is the size of a papaya. Baby is getting into position for birth. Lungs are nearly fully developed.',
        sizeComparison: '🍈 Papaya (47.4 cm)',
        motherChanges: 'You may feel baby "dropping" lower. Braxton Hicks contractions may increase.',
        tips: ['Have weekly checkups', 'Watch for signs of labor', 'Stay positive and relaxed'],
        createdAt: now,
        updatedAt: now,
      ),
      WeeklyDevelopment(
        id: _uuid.v4(),
        week: 40,
        title: 'Size of a Watermelon',
        description: 'Full term! Baby is about the size of a watermelon. Baby is ready to meet you!',
        sizeComparison: '🍉 Watermelon (51.2 cm)',
        motherChanges: 'You may experience nesting instincts. Labor could start any day now!',
        tips: ['Stay close to home', 'Rest and conserve energy', 'Trust your body'],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await prefs.setString(
      _developmentsKey,
      jsonEncode(_developments.map((e) => e.toJson()).toList()),
    );
  }

  WeeklyDevelopment? getDevelopmentByWeek(int week) {
    try {
      return _developments.firstWhere((d) => d.week == week);
    } catch (e) {
      final closestWeek = _developments.reduce((a, b) => 
        (a.week - week).abs() < (b.week - week).abs() ? a : b
      );
      return closestWeek;
    }
  }
}

