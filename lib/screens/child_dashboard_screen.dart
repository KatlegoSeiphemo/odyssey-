import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/services/vaccination_service.dart';
import 'package:flutter_application_1/services/milestone_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/theme.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = context.read<AuthService>().currentUser!.id;
      await context.read<ChildService>().loadChildren(userId);
      
      final children = context.read<ChildService>().children;
      if (children.isNotEmpty) {
        await Future.wait([
          context.read<VaccinationService>().initialize(),
          context.read<VaccinationService>().loadRecords(children.first.id),
          context.read<MilestoneService>().initialize(),
        ]);
        // Schedule vaccination reminders for the first child
        try {
          final child = children.first;
          final vaccinationService = context.read<VaccinationService>();
          final upcoming = vaccinationService.getUpcomingVaccinations(child.ageInMonths);
          await NotificationService.instance.scheduleUpcomingVaccinationsForChild(
            child: child,
            vaccinations: upcoming,
            isComplete: (vaccinationId) => vaccinationService.isVaccinationComplete(vaccinationId, child.id),
          );
        } catch (e) {
          debugPrint('Failed to schedule vaccination reminders: $e');
        }
      }
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

    final childService = context.watch<ChildService>();
    final children = childService.children;

    if (children.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No child profile found')),
      );
    }

    final child = children.first;
    final vaccinationService = context.watch<VaccinationService>();
    final dueVaccinations = vaccinationService.getDueVaccinations(child.ageInMonths);
    final completedCount = dueVaccinations.where((v) => vaccinationService.isVaccinationComplete(v.id, child.id)).length;
    final milestoneService = context.watch<MilestoneService>();
    final milestones = milestoneService.getMilestonesByAge(child.ageInMonths);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Development'),
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
                color: Theme.of(context).colorScheme.secondaryContainer,
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
                                  child.name,
                                  style: context.textStyles.headlineLarge?.bold,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${child.ageInMonths} months old',
                                  style: context.textStyles.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            child.gender == 'Male' ? Icons.boy : Icons.girl,
                            size: 64,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Born: ${DateFormat.yMMMd().format(child.birthDate)}',
                        style: context.textStyles.bodyLarge?.semiBold,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Vaccination Progress', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              Card(
                child: InkWell(
                  onTap: () => context.push('/vaccinations'),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.vaccines, size: 32, color: Theme.of(context).colorScheme.tertiary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$completedCount of ${dueVaccinations.length} completed',
                                    style: context.textStyles.titleLarge?.semiBold,
                                  ),
                                  Text(
                                    'Keep your child protected',
                                    style: context.textStyles.bodyMedium?.withColor(
                                      Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: dueVaccinations.isEmpty ? 0 : completedCount / dueVaccinations.length,
                            minHeight: 8,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Developmental Milestones', style: context.textStyles.titleLarge?.bold),
                  TextButton(
                    onPressed: () => context.push('/milestones'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (milestones.isEmpty)
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Center(
                      child: Text(
                        'No milestones yet',
                        style: context.textStyles.bodyMedium,
                      ),
                    ),
                  ),
                )
              else
                ...milestones.take(4).map((milestone) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        milestone.icon ?? '🎯',
                        style: const TextStyle(fontSize: 32),
                      ),
                      title: Text(milestone.title, style: context.textStyles.titleMedium?.semiBold),
                      subtitle: Text(
                        milestone.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${milestone.weekOrMonth}mo',
                          style: context.textStyles.bodySmall?.semiBold,
                        ),
                      ),
                      onTap: () => context.push('/milestones'),
                    ),
                  ),
                )),
              const SizedBox(height: 24),
              Card(
                child: InkWell(
                  onTap: () => context.push('/growth-tracking'),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Row(
                      children: [
                        Icon(Icons.show_chart, size: 32, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Growth Tracking',
                                style: context.textStyles.titleMedium?.semiBold,
                              ),
                              Text(
                                'Monitor height, weight, and development',
                                style: context.textStyles.bodyMedium?.withColor(
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
