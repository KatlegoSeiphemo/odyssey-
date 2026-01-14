import 'package:flutter/foundation.dart';

/// Represents the logged-in user.
class User {
  final String id; // unique identifier
  final String name;
  final String email;
  String selectedModule;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.selectedModule = 'pregnancy',
  });
}

/// AuthService handles simple authentication and user session.
class AuthService extends ChangeNotifier {
  User? currentUser;
  bool _isLoggedIn = false;

  /// Whether a user is currently logged in
  bool get isLoggedIn => _isLoggedIn;

  AuthService();

  /// Simulates initialization (load user from storage, etc.)
  Future<void> initialize() async {
    // For demo: pretend we load a stored user
    await Future.delayed(const Duration(milliseconds: 200));
    // If you want persistent login, load user from SharedPreferences here
  }

  /// Registers a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Logs in an existing user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Demo User',
      email: email,
    );

    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Logs out the current user
  Future<void> logout() async {
    currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Update the selected module for the current user
  Future<void> updateUserModule(String module) async {
    if (currentUser != null) {
      currentUser!.selectedModule = module;
      notifyListeners();
    }
  }
}
