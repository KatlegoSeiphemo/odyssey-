import 'package:flutter/material.dart';
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
  List children = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Cache services before async calls
      final authService = context.read<AuthService>();
      final childService = context.read<ChildService>();
      final vaccinationService = context.read<VaccinationService>();
      final milestoneService = context.read<MilestoneService>();

      final currentUser = authService.currentUser;
      if (currentUser == null) return;

      final userId = currentUser.id;

      // Load children first
      await childService.loadChildren(userId);

      final loadedChildren = childService.children;
      if (loadedChildren.isNotEmpty) {
        final firstChild = loadedChildren.first;

        await Future.wait([
          vaccinationService.initialize(),
          vaccinationService.loadRecords(firstChild.id),
          milestoneService.initialize(),
        ]);

        // Schedule notifications safely
        try {
          final upcoming = vaccinationService.getUpcomingVaccinations(firstChild.ageInMonths);
          await NotificationService.instance.scheduleUpcomingVaccinationsForChild(
            child: firstChild,
            vaccinations: upcoming,
            isComplete: (vaccinationId) =>
                vaccinationService.isVaccinationComplete(vaccinationId, firstChild.id),
          );
        } catch (e) {
          debugPrint('Failed to schedule vaccination reminders: $e');
        }
      }

      if (!mounted) return;
      setState(() {
        children = loadedChildren;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading child dashboard: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (children.isEmpty) {
      return const Scaffold(body: Center(child: Text('No child profile found')));
    }

    final child = children.first;
    final vaccinationService = context.watch<VaccinationService>();
    final milestoneService = context.watch<MilestoneService>();

    final dueVaccinations = vaccinationService.getDueVaccinations(child.ageInMonths);
    final completedCount =
        dueVaccinations.where((v) => vaccinationService.isVaccinationComplete(v.id, child.id)).length;

    final milestones = milestoneService.getMilestonesByAge(child.ageInMonths);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Development'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Child info card
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(child.name, style: context.textStyles.headlineLarge?.bold),
                            const SizedBox(height: 4),
                            Text('${child.ageInMonths} months old', style: context.textStyles.titleMedium),
                            const SizedBox(height: 4),
                            Text('Born: ${DateFormat.yMMMd().format(child.birthDate)}',
                                style: context.textStyles.bodyLarge?.semiBold),
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
                ),
              ),
              const SizedBox(height: 24),

              // Vaccination Progress
              Text('Vaccination Progress', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              Card(
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
                                Text('$completedCount of ${dueVaccinations.length} completed',
                                    style: context.textStyles.titleLarge?.semiBold),
                                Text('Keep your child protected',
                                    style: context.textStyles.bodyMedium?.withColor(
                                        Theme.of(context).colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
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
              const SizedBox(height: 24),

              // Milestones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Developmental Milestones', style: context.textStyles.titleLarge?.bold),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (milestones.isEmpty)
                Card(
                  child: Padding(
                    padding: AppSpacing.paddingMd,
                    child: Center(child: Text('No milestones yet', style: context.textStyles.bodyMedium)),
                  ),
                )
              else
                ...milestones.take(4).map((milestone) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          leading: Text(milestone.icon ?? '🎯', style: const TextStyle(fontSize: 32)),
                          title: Text(milestone.title, style: context.textStyles.titleMedium?.semiBold),
                          subtitle: Text(milestone.description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${milestone.weekOrMonth}mo', style: context.textStyles.bodySmall?.semiBold),
                          ),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
