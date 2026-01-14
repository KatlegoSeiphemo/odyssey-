import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/services/milestone_service.dart';
import 'package:flutter_application_1/theme.dart';

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final childService = context.watch<ChildService>();
    final milestoneService = context.watch<MilestoneService>();

    if (childService.children.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No child profile found')),
      );
    }

    final child = childService.children.first;
    final achievedMilestones = milestoneService.getMilestonesByAge(child.ageInMonths);
    final allMilestones = milestoneService.getMilestonesByType('child');
    final upcomingMilestones = allMilestones
        .where((m) => m.weekOrMonth > child.ageInMonths)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Milestones'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Achieved'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MilestoneList(
              milestones: achievedMilestones,
              isAchieved: true,
              childAge: child.ageInMonths,
            ),
            _MilestoneList(
              milestones: upcomingMilestones,
              isAchieved: false,
              childAge: child.ageInMonths,
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneList extends StatelessWidget {
  final List milestones;
  final bool isAchieved;
  final int childAge;

  const _MilestoneList({
    required this.milestones,
    required this.isAchieved,
    required this.childAge,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${isAchieved ? 'achieved' : 'upcoming'} milestones',
              style: context.textStyles.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.paddingMd,
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        final isRecent = isAchieved && (childAge - milestone.weekOrMonth) <= 2;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            color: isRecent 
                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)
                : null,
            child: ListTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isAchieved
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    milestone.icon ?? '🎯',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              title: Text(
                milestone.title,
                style: context.textStyles.titleMedium?.semiBold,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(milestone.description),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${milestone.weekOrMonth} months',
                          style: context.textStyles.bodySmall?.semiBold,
                        ),
                      ),
                      if (isRecent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Recent! 🎉',
                            style: context.textStyles.bodySmall?.semiBold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: isAchieved
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                  : Icon(Icons.schedule, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        );
      },
    );
  }
}

