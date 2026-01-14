import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/theme.dart';

class GrowthTrackingScreen extends StatelessWidget {
  const GrowthTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final childService = context.watch<ChildService>();

    if (childService.children.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No child profile found')),
      );
    }

    final child = childService.children.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Growth Tracking'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
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
                                  child.name,
                                  style: context.textStyles.headlineMedium?.bold,
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
                            Icons.child_care,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Growth Milestones', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.height, color: Theme.of(context).colorScheme.primary),
                        title: const Text('Height/Length'),
                        subtitle: const Text('Track growth over time'),
                        trailing: const Icon(Icons.add),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.monitor_weight, color: Theme.of(context).colorScheme.secondary),
                        title: const Text('Weight'),
                        subtitle: const Text('Monitor weight gain'),
                        trailing: const Icon(Icons.add),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.circle_outlined, color: Theme.of(context).colorScheme.tertiary),
                        title: const Text('Head Circumference'),
                        subtitle: const Text('Track head growth'),
                        trailing: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(height: 16),
                      Text(
                        'Coming Soon',
                        style: context.textStyles.titleLarge?.bold,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Growth tracking with charts and percentile calculations will be available in the next update.',
                        style: context.textStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
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
