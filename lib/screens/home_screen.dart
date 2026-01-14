import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService?>(context);

    // Minimal behavior for unresolved AuthService in tests/dev: show a placeholder
    if (authService == null || !authService.isLoggedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (!authService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authService.currentUser!;
    
    if (user.selectedModule == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/module-selection');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user.selectedModule == 'pregnancy') {
        context.go('/pregnancy-dashboard');
      } else {
        context.go('/child-dashboard');
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
