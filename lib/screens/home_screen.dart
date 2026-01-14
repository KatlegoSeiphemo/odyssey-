import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthService from Provider
    final authService = Provider.of<AuthService?>(context);

    // If AuthService is not ready or the user is not logged in, show a loading spinner
    if (authService == null || !authService.isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Once logged in, show the main home screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // const is OK here
      ),
      body: const Center(
        child: Text('Home'), // const is OK here
      ),
    );
  }
}
