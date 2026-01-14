import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/child_service.dart';
import 'package:flutter_application_1/models/child_profile.dart';
import 'package:flutter_application_1/theme.dart';

class ChildSetupScreen extends StatefulWidget {
  const ChildSetupScreen({super.key});

  @override
  State<ChildSetupScreen> createState() => _ChildSetupScreenState();
}

class _ChildSetupScreenState extends State<ChildSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _uuid = const Uuid();
  DateTime? _birthDate;
  String _gender = 'Male';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 180)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final userId = context.read<AuthService>().currentUser!.id;
    final now = DateTime.now();
    
    final child = ChildProfile(
      id: _uuid.v4(),
      userId: userId,
      name: _nameController.text.trim(),
      birthDate: _birthDate!,
      gender: _gender,
      createdAt: now,
      updatedAt: now,
    );

    await context.read<ChildService>().addChild(child);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/child-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Profile Setup'),
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
                  'assets/images/Baby_development_null_1768296666742.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Text(
                  'Tell Us About Your Child',
                  style: context.textStyles.headlineMedium?.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll help you track their growth and milestones',
                  style: context.textStyles.bodyMedium?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Child\'s Name',
                    hintText: 'Enter child\'s name',
                    prefixIcon: Icon(Icons.child_care),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter child\'s name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: InkWell(
                    onTap: _selectBirthDate,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Padding(
                      padding: AppSpacing.paddingMd,
                      child: Row(
                        children: [
                          Icon(Icons.cake, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birth Date',
                                  style: context.textStyles.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _birthDate != null
                                      ? DateFormat.yMMMd().format(_birthDate!)
                                      : 'Tap to select',
                                  style: context.textStyles.bodyMedium?.withColor(
                                    _birthDate != null
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
                const SizedBox(height: 16),
                Text('Gender', style: context.textStyles.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Male', label: Text('Male'), icon: Icon(Icons.boy)),
                    ButtonSegment(value: 'Female', label: Text('Female'), icon: Icon(Icons.girl)),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (Set<String> selected) {
                    setState(() => _gender = selected.first);
                  },
                ),
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
