import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/models/nutrition.dart';

class NutritionService extends ChangeNotifier {
  static const _nutritionKey = 'nutrition_data';
  final Uuid _uuid = const Uuid();
  List<Nutrition> _nutritionList = [];
  bool _isInitialized = false;

  List<Nutrition> get nutritionList => _nutritionList;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final nutritionJson = prefs.getString(_nutritionKey);
      
      if (nutritionJson != null) {
        _nutritionList = (jsonDecode(nutritionJson) as List)
            .map((e) => Nutrition.fromJson(e))
            .toList();
      } else {
        await _initializeSampleData(prefs);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize nutrition data: $e');
    }
  }

  Future<void> _initializeSampleData(SharedPreferences prefs) async {
    final now = DateTime.now();
    _nutritionList = [
      Nutrition(
        id: _uuid.v4(),
        trimester: 1,
        category: 'Supplement',
        name: 'Folic Acid',
        description: '400-800 mcg daily',
        benefits: 'Prevents neural tube defects and supports early development',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 1,
        category: 'Food',
        name: 'Leafy Greens',
        description: 'Spinach, kale, broccoli',
        benefits: 'Rich in folate, iron, and calcium for baby\'s development',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 1,
        category: 'Food',
        name: 'Citrus Fruits',
        description: 'Oranges, grapefruit, lemons',
        benefits: 'High in vitamin C, helps with iron absorption and immune system',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 2,
        category: 'Supplement',
        name: 'Iron',
        description: '27 mg daily',
        benefits: 'Prevents anemia and supports increased blood volume',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 2,
        category: 'Food',
        name: 'Lean Protein',
        description: 'Chicken, fish, eggs, beans',
        benefits: 'Essential for baby\'s growth and muscle development',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 2,
        category: 'Food',
        name: 'Dairy Products',
        description: 'Milk, yogurt, cheese',
        benefits: 'Provides calcium and protein for bone development',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 3,
        category: 'Supplement',
        name: 'Calcium',
        description: '1000 mg daily',
        benefits: 'Supports bone development and prevents maternal bone loss',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 3,
        category: 'Food',
        name: 'Omega-3 Rich Fish',
        description: 'Salmon, sardines (low mercury)',
        benefits: 'Supports brain and eye development',
        createdAt: now,
        updatedAt: now,
      ),
      Nutrition(
        id: _uuid.v4(),
        trimester: 3,
        category: 'Food',
        name: 'Whole Grains',
        description: 'Brown rice, oats, quinoa',
        benefits: 'Provides energy and fiber to prevent constipation',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    await prefs.setString(
      _nutritionKey,
      jsonEncode(_nutritionList.map((e) => e.toJson()).toList()),
    );
  }

  List<Nutrition> getByTrimester(int trimester) =>
      _nutritionList.where((n) => n.trimester == trimester).toList();

  List<Nutrition> getByCategory(String category) =>
      _nutritionList.where((n) => n.category == category).toList();
}
