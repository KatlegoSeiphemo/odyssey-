import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/user.dart';

class AuthService extends ChangeNotifier {
  bool isLoggedIn = false;
  User? currentUser;

  Future<void> initialize() async {
    // Minimal initializer for tests and analysis
    isLoggedIn = false;
    currentUser = null;
  }

  Future<void> updateUserModule(String module) async {
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(selectedModule: module);
      notifyListeners();
    }
  }
}

