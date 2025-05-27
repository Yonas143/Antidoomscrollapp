// lib/features/goals/presentation/goal_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/goal_controller.dart';

class GoalForm extends ConsumerStatefulWidget {
  const GoalForm({super.key});

  @override
  ConsumerState<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends ConsumerState<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  String platform = '';
  int limit = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Platform (e.g., Instagram)'),
                onChanged: (val) => platform = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Daily Limit (in minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => limit = int.tryParse(val) ?? 0,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await ref
                        .read(goalControllerProvider.notifier)
                        .create(platform, limit);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Goal added!')),
                    );
                    _formKey.currentState!.reset();
                  }
                },
                child: const Text('Set Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
