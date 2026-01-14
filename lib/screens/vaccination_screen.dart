import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/services/vaccination_service.dart';
import 'package:flutter_application_1/models/vaccination_record.dart';
import 'package:flutter_application_1/theme.dart';
import 'package:flutter_application_1/services/export_service.dart';
class VaccinationsScreen extends StatelessWidget {
  const VaccinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final childService = context.watch<ChildService>();
    final vaccinationService = context.watch<VaccinationService>();
    
    if (childService.children.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No child profile found')),
      );
    }

    final child = childService.children.first;
    final allVaccinations = vaccinationService.vaccinations;
    final dueVaccinations = vaccinationService.getDueVaccinations(child.ageInMonths);
    final upcomingVaccinations = vaccinationService.getUpcomingVaccinations(child.ageInMonths);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vaccinations'),
          actions: [
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Export',
              onPressed: () async {
                try {
                  final child = context.read<ChildService>().children.first;
                  final vaccinationService = context.read<VaccinationService>();
                  final vaccinations = vaccinationService.vaccinations;
                  final records = vaccinationService.records;
                  if (vaccinations.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No vaccination data to export')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating PDF...')),
                  );
                  await ExportService.shareVaccinationPdf(
                    child: child,
                    vaccinations: vaccinations,
                    records: records,
                  );
                } catch (e) {
                  debugPrint('Export failed: $e');
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to export PDF')),
                  );
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Due Now'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _VaccinationList(
              vaccinations: dueVaccinations,
              child: child,
              isDue: true,
            ),
            _VaccinationList(
              vaccinations: upcomingVaccinations,
              child: child,
              isDue: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _VaccinationList extends StatelessWidget {
  final List vaccinations;
  final child;
  final bool isDue;

  const _VaccinationList({
    required this.vaccinations,
    required this.child,
    required this.isDue,
  });

  @override
  Widget build(BuildContext context) {
    final vaccinationService = context.watch<VaccinationService>();

    if (vaccinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${isDue ? 'due' : 'upcoming'} vaccinations',
              style: context.textStyles.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.paddingMd,
      itemCount: vaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = vaccinations[index];
        final isComplete = vaccinationService.isVaccinationComplete(vaccination.id, child.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isComplete
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.tertiaryContainer,
                child: Icon(
                  isComplete ? Icons.check : Icons.vaccines,
                  color: isComplete
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                ),
              ),
              title: Text(
                vaccination.name,
                style: context.textStyles.titleMedium?.semiBold,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vaccination.description),
                  const SizedBox(height: 4),
                  Text(
                    'Recommended at ${vaccination.ageInMonths} months',
                    style: context.textStyles.bodySmall?.withColor(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              trailing: isComplete
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary)
                  : null,
              onTap: isDue && !isComplete
                  ? () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Mark as Completed'),
                          content: Text('Did ${child.name} receive the ${vaccination.name} vaccination?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        const uuid = Uuid();
                        final record = VaccinationRecord(
                          id: uuid.v4(),
                          childId: child.id,
                          vaccinationId: vaccination.id,
                          dateGiven: DateTime.now(),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        await context.read<VaccinationService>().addRecord(record);
                      }
                    }
                  : null,
            ),
          ),
        );
      },
    );
  }
}