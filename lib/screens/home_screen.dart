import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService?>(context);

    // Minimal behavior for tests/dev: show a placeholder until auth resolves
    if (authService == null || !authService.isLoggedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home')),
    );
  }
}
