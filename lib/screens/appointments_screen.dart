import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/theme.dart';
import 'package:flutter_application_1/services/appointment_service.dart';


class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentService = context.watch<AppointmentService>();
    final upcoming = appointmentService.getUpcoming();
    final past = appointmentService.getPast();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AppointmentList(appointments: upcoming, isPast: false),
            _AppointmentList(appointments: past, isPast: true),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-appointment'),
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List appointments;
  final bool isPast;

  const _AppointmentList({
    required this.appointments,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${isPast ? 'past' : 'upcoming'} appointments',
              style: context.textStyles.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.paddingMd,
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: apt.isCompleted
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(
                  Icons.medical_services,
                  color: apt.isCompleted
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: Text(
                apt.title,
                style: context.textStyles.titleMedium?.semiBold,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat.yMMMd().add_jm().format(apt.dateTime)),
                  if (apt.location != null)
                    Text('📍 ${apt.location}', style: context.textStyles.bodySmall),
                ],
              ),
              trailing: apt.isCompleted
                  ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary)
                  : const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                if (!apt.isCompleted) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Mark as Completed'),
                      content: Text('Mark "${apt.title}" as completed?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    final updated = apt.copyWith(isCompleted: true);
                    await context.read<AppointmentService>().updateAppointment(updated);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
