// lib/features/mindful_activities/presentation/activity_list_page.dart

import 'package:flutter/material.dart';

class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mindful Activities')),
      body: const Center(child: Text('Activity List Page')),
    );
  }
}
