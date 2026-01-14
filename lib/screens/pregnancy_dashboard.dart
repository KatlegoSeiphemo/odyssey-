import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/pregnancy_service.dart';
import 'package:flutter_application_1/services/weekly_development_service.dart';
import 'package:flutter_application_1/services/nutrition_service.dart';
import 'package:flutter_application_1/services/appointment_service.dart';
import 'package:flutter_application_1/theme.dart';

class PregnancyDashboardScreen extends StatefulWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  State<PregnancyDashboardScreen> createState() => _PregnancyDashboardScreenState();
}

class _PregnancyDashboardScreenState extends State<PregnancyDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = context.read<AuthService>().currentUser!.id;
      await Future.wait([
        context.read<PregnancyService>().loadProfile(userId),
        context.read<WeeklyDevelopmentService>().initialize(),
        context.read<NutritionService>().initialize(),
        context.read<AppointmentService>().loadAppointments(userId),
      ]);
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pregnancyService = context.watch<PregnancyService>();
    final profile = pregnancyService.currentProfile;

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Profile not found')),
      );
    }

    final weeklyDevService = context.watch<WeeklyDevelopmentService>();
    final currentWeekDev = weeklyDevService.getDevelopmentByWeek(profile.currentWeek);
    final nutritionService = context.watch<NutritionService>();
    final trimester = ((profile.currentWeek - 1) / 13).ceil().clamp(1, 3);
    final trimesterNutrition = nutritionService.getByTrimester(trimester);
    final appointmentService = context.watch<AppointmentService>();
    final upcomingAppointments = appointmentService.getUpcoming();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Journey'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Week ${profile.currentWeek}',
                                  style: context.textStyles.headlineLarge?.bold,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Trimester $trimester',
                                  style: context.textStyles.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.pregnant_woman,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Due Date: ${DateFormat.yMMMd().format(profile.dueDate)}',
                        style: context.textStyles.bodyLarge?.semiBold,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.dueDate.difference(DateTime.now()).inDays} days to go',
                        style: context.textStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (currentWeekDev != null) ...[
                Text('This Week', style: context.textStyles.titleLarge?.bold),
                const SizedBox(height: 12),
                Card(
                  child: InkWell(
                    onTap: () => context.push('/weekly-development', extra: currentWeekDev),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                currentWeekDev.sizeComparison.split(' ')[0],
                                style: const TextStyle(fontSize: 40),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentWeekDev.title,
                                      style: context.textStyles.titleLarge?.bold,
                                    ),
                                    Text(
                                      currentWeekDev.sizeComparison,
                                      style: context.textStyles.bodyMedium?.withColor(
                                        Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentWeekDev.description,
                            style: context.textStyles.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming Appointments', style: context.textStyles.titleLarge?.bold),
                  TextButton(
                    onPressed: () => context.push('/appointments'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (upcomingAppointments.isEmpty)
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Row(
                      children: [
                        Icon(Icons.event_available, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No upcoming appointments',
                            style: context.textStyles.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/add-appointment'),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...upcomingAppointments.take(2).map((apt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        child: Icon(
                          Icons.medical_services,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      title: Text(apt.title, style: context.textStyles.titleMedium?.semiBold),
                      subtitle: Text(DateFormat.yMMMd().add_jm().format(apt.dateTime)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/appointments'),
                    ),
                  ),
                )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nutrition Guide', style: context.textStyles.titleLarge?.bold),
                  TextButton(
                    onPressed: () => context.push('/nutrition'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...trimesterNutrition.take(3).map((nutrition) {
                final n = nutrition as dynamic;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (n?.category ?? '') == 'Supplement'
                            ? Theme.of(context).colorScheme.tertiaryContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          (n?.category ?? '') == 'Supplement' ? Icons.medication : Icons.restaurant,
                          color: (n?.category ?? '') == 'Supplement'
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(n?.name ?? '', style: context.textStyles.titleMedium?.semiBold),
                      subtitle: Text(
                        n?.description ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push('/nutrition'),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-appointment'),
        icon: const Icon(Icons.add),
        label: const Text('Add Appointment'),
      ),
    );
  }
}
