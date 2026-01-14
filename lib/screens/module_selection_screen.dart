import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/theme.dart';

class ModuleSelectionScreen extends StatelessWidget {
  const ModuleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.favorite,
                  size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Choose Your Journey',
                style: context.textStyles.headlineLarge?.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the module that fits your current parenting stage',
                style: context.textStyles.bodyLarge
                    ?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ModuleCard(
                      icon: Icons.pregnant_woman,
                      title: 'Pregnancy Tracking',
                      description:
                          'Track your pregnancy journey with weekly updates, nutrition guidance, and appointment reminders',
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () async {
                        await context
                            .read<AuthService>()
                            .updateUserModule('pregnancy');
                        if (context.mounted) context.go('/pregnancy-setup');
                      },
                    ),
                    const SizedBox(height: 24),
                    ModuleCard(
                      icon: Icons.child_care,
                      title: 'Child Development',
                      description:
                          'Monitor your child\'s growth, track milestones, and manage vaccination schedules',
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () async {
                        await context
                            .read<AuthService>()
                            .updateUserModule('child');
                        if (context.mounted) context.go('/child-setup');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: context.textStyles.titleLarge?.bold.withColor(color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: context.textStyles.bodyMedium
                    ?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
