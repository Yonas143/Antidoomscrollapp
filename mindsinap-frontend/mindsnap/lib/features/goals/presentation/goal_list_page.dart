// lib/features/goals/presentation/goal_list_page.dart

import 'package:flutter/material.dart';

class GoalListPage extends StatelessWidget {
  const GoalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Media Goals')),
      body: const Center(child: Text('Goal List Page')),
    );
  }
}
