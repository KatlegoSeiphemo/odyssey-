import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_application_1/screens/module_selection_screen.dart';
import 'package:flutter_application_1/screens/pregnancy_setup.dart';
import 'package:flutter_application_1/screens/pregnancy_dashboard.dart';
import 'package:flutter_application_1/screens/child_setup.dart';
import 'package:flutter_application_1/screens/child_dashboard_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/weekly_development_screen.dart';
import 'package:flutter_application_1/screens/nutrition_screen.dart';
import 'package:flutter_application_1/screens/appointments_screen.dart';
import 'package:flutter_application_1/screens/add_appointment.dart';
import 'package:flutter_application_1/screens/vaccination_screen.dart';
import 'package:flutter_application_1/screens/milestones_screen.dart';
import 'package:flutter_application_1/screens/growth_tracking.dart';
import 'package:flutter_application_1/models/weekly_development.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RegisterScreen()),
      ),
      GoRoute(
        path: AppRoutes.moduleSelection,
        name: 'module-selection',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ModuleSelectionScreen()),
      ),
      GoRoute(
        path: AppRoutes.pregnancySetup,
        name: 'pregnancy-setup',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PregnancySetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.pregnancyDashboard,
        name: 'pregnancy-dashboard',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: PregnancyDashboardScreen()),
      ),
      GoRoute(
        path: AppRoutes.childSetup,
        name: 'child-setup',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ChildSetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.childDashboard,
        name: 'child-dashboard',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ChildDashboardScreen()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.weeklyDevelopment,
        name: 'weekly-development',
        pageBuilder: (context, state) {
          final development = state.extra as WeeklyDevelopment;
          return MaterialPage(
              child: WeeklyDevelopmentScreen(development: development));
        },
      ),
      GoRoute(
        path: AppRoutes.nutrition,
        name: 'nutrition',
        pageBuilder: (context, state) =>
            const MaterialPage(child: NutritionScreen()),
      ),
      GoRoute(
        path: AppRoutes.appointments,
        name: 'appointments',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppointmentsScreen()),
      ),
      GoRoute(
        path: AppRoutes.addAppointment,
        name: 'add-appointment',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AddAppointmentScreen()),
      ),
      GoRoute(
        path: AppRoutes.vaccinations,
        name: 'vaccinations',
        pageBuilder: (context, state) =>
            const MaterialPage(child: VaccinationsScreen()),
      ),
      GoRoute(
        path: AppRoutes.milestones,
        name: 'milestones',
        pageBuilder: (context, state) =>
            const MaterialPage(child: MilestonesScreen()),
      ),
      GoRoute(
        path: AppRoutes.growthTracking,
        name: 'growth-tracking',
        pageBuilder: (context, state) =>
            const MaterialPage(child: GrowthTrackingScreen()),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String moduleSelection = '/module-selection';
  static const String pregnancySetup = '/pregnancy-setup';
  static const String pregnancyDashboard = '/pregnancy-dashboard';
  static const String childSetup = '/child-setup';
  static const String childDashboard = '/child-dashboard';
  static const String profile = '/profile';
  static const String weeklyDevelopment = '/weekly-development';
  static const String nutrition = '/nutrition';
  static const String appointments = '/appointments';
  static const String addAppointment = '/add-appointment';
  static const String vaccinations = '/vaccinations';
  static const String milestones = '/milestones';
  static const String growthTracking = '/growth-tracking';
}
