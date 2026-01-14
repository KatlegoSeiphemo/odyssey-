import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/weekly_development.dart';
import 'package:flutter_application_1/theme.dart';

class WeeklyDevelopmentScreen extends StatelessWidget {
  final WeeklyDevelopment development;

  const WeeklyDevelopmentScreen({
    super.key,
    required this.development,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week ${development.week}'),
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
                  child: Row(
                    children: [
                      Text(
                        development.sizeComparison.split(' ')[0],
                        style: const TextStyle(fontSize: 64),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              development.title,
                              style: context.textStyles.headlineSmall?.bold,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              development.sizeComparison,
                              style: context.textStyles.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Baby\'s Development', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: Text(
                    development.description,
                    style: context.textStyles.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Your Body Changes', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: Text(
                    development.motherChanges,
                    style: context.textStyles.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Tips for This Week', style: context.textStyles.titleLarge?.bold),
              const SizedBox(height: 12),
              ...development.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(tip, style: context.textStyles.bodyLarge),
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
