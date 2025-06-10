// lib/features/goals/presentation/goal_form_page.dart

import 'package:flutter/material.dart';

class GoalFormPage extends StatelessWidget {
  const GoalFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Goal')),
      body: const Center(child: Text('Goal Form Page')),
    );
  }
}
