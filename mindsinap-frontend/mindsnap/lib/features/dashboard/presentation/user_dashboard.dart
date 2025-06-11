// lib/features/dashboard/presentation/user_dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for potential logout
import 'package:mindsnap/core/providers.dart';         // Added for potential logout
import '../../goals/presentation/goal_form.dart';
import '../../goals/presentation/goal_list.dart'; // This widget needs the fix internally
import '../../mindful_activities/presentation/activity_form.dart';
import '../../mindful_activities/presentation/activity_list.dart'; // This widget likely needs a similar fix

class UserDashboard extends ConsumerWidget { // Changed to ConsumerWidget for logout
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    print("Building UserDashboard UI");
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              // GoRouter's redirect logic should handle navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Added some padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
          children: <Widget>[
            // Potentially add a welcome message or other dashboard-specific info here
            const Text("Mindful Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const ActivityForm(), // Assuming this is a simple form
            const SizedBox(height: 8),
            const Text("Your Activities:", style: TextStyle(fontSize: 16)), // Added a header for the list
            const ActivityList(), // Assumes ActivityList fetches its own data and handles AsyncValue

            const Divider(height: 32, thickness: 1),

            const Text("Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const GoalForm(),     // Assuming this is a simple form
            const SizedBox(height: 8),
            const Text("Your Goals:", style: TextStyle(fontSize: 16)), // Added a header for the list
            const GoalList(),     // Assumes GoalList fetches its own data and handles AsyncValue
          ],
        ),
      ),
    );
  }
}