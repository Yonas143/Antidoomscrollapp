// lib/features/mindful_activities/presentation/activity_form_page.dart

import 'package:flutter/material.dart';

class ActivityFormPage extends StatelessWidget {
  const ActivityFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Mindful Activity')),
      body: const Center(child: Text('Activity Form Page')),
    );
  }
}
