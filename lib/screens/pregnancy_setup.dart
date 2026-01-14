import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/pregnancy_service.dart';
import 'package:flutter_application_1/theme.dart';

class PregnancySetupScreen extends StatefulWidget {
  const PregnancySetupScreen({super.key});

  @override
  State<PregnancySetupScreen> createState() => _PregnancySetupScreenState();
}

class _PregnancySetupScreenState extends State<PregnancySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastPeriodDate;
  DateTime? _dueDate;
  bool _isLoading = false;

  Future<void> _selectLastPeriodDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 56)),
      firstDate: DateTime.now().subtract(const Duration(days: 280)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
        _dueDate = picked.add(const Duration(days: 280));
      });
    }
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate() || _lastPeriodDate == null || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your last period date')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final userId = context.read<AuthService>().currentUser!.id;
    await context.read<PregnancyService>().createProfile(userId, _dueDate!, _lastPeriodDate!);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/pregnancy-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Setup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/Pregnant_woman_health_null_1768296665409.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text(
                  'Let\'s Get Started',
                  style: context.textStyles.headlineMedium?.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your pregnancy to personalize your experience',
                  style: context.textStyles.bodyMedium?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  child: InkWell(
                    onTap: _selectLastPeriodDate,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Period Date',
                                  style: context.textStyles.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _lastPeriodDate != null
                                      ? DateFormat.yMMMd().format(_lastPeriodDate!)
                                      : 'Tap to select',
                                  style: context.textStyles.bodyMedium?.withColor(
                                    _lastPeriodDate != null
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
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
                if (_dueDate != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Row(
                        children: [
                          Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated Due Date',
                                  style: context.textStyles.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat.yMMMd().format(_dueDate!),
                                  style: context.textStyles.bodyLarge?.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _createProfile,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
