// lib/features/dashboard/presentation/user_dashboard.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: const Text('📘 Mindful Activities'),
            subtitle: const Text('Create and manage your mindful habits.'),
            onTap: () => context.go('/activities'),
          ),
          const Divider(),
          ListTile(
            title: const Text('🎯 Social Media Goals'),
            subtitle: const Text('Track and manage your goals.'),
            onTap: () => context.go('/goals'),
          ),
        ],
      ),
    );
  }
}
