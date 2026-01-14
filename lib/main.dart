import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/theme.dart';
import 'package:flutter_application_1/nav.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/pregnancy_service.dart';
import 'package:flutter_application_1/services/weekly_development_service.dart';
import 'package:flutter_application_1/services/nutrition_service.dart';
import 'package:flutter_application_1/services/appointment_service.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/services/vaccination_service.dart';
import 'package:flutter_application_1/services/milestone_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.initialize();
  await NotificationService.instance.init();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (_) => PregnancyService()),
        ChangeNotifierProvider(create: (_) => WeeklyDevelopmentService()),
        ChangeNotifierProvider(create: (_) => NutritionService()),
        ChangeNotifierProvider(create: (_) => AppointmentService()),
        ChangeNotifierProvider(create: (_) => ChildService()),
        ChangeNotifierProvider(create: (_) => VaccinationService()),
        ChangeNotifierProvider(create: (_) => MilestoneService()),
      ],
      child: MaterialApp.router(
        title: 'flutter_application_1',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
