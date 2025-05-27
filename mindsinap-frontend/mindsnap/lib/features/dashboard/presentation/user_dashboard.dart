// lib/features/dashboard/presentation/user_dashboard.dart

import 'package:flutter/material.dart';
import '../../mindful_activities/presentation/activity_form.dart';
import '../../mindful_activities/presentation/activity_list.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ActivityForm(),
            Divider(),
            ActivityList(),
          ],
        ),
      ),
    );
  }
}
