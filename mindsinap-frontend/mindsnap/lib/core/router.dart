import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pages
import 'package:mindsnap/features/auth/presentation/login_page.dart';
import 'package:mindsnap/features/auth/presentation/register_page.dart';
import 'package:mindsnap/features/dashboard/presentation/user_dashboard.dart';
import 'package:mindsnap/features/dashboard/presentation/admin_dashboard.dart';
import 'package:mindsnap/features/mindful_activities/presentation/activity_list.dart';
import 'package:mindsnap/features/mindful_activities/presentation/activity_form.dart';
import 'package:mindsnap/features/goals/presentation/goal_list.dart';
import 'package:mindsnap/features/goals/presentation/goal_form.dart';
import 'package:mindsnap/features/admin/presentation/user_list.dart';

// Widgets
import 'package:mindsnap/widgets/navbar.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard/user',
      builder: (context, state) => const UserDashboard(),
    ),
    GoRoute(
      path: '/dashboard/admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/activities',
      builder: (context, state) => const ActivityListPage(),
    ),
    GoRoute(
      path: '/activities/new',
      builder: (context, state) => const ActivityFormPage(),
    ),
    GoRoute(
      path: '/goals',
      builder: (context, state) => const GoalListPage(),
    ),
    GoRoute(
      path: '/goals/new',
      builder: (context, state) => const GoalFormPage(),
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const UserListPage(),
    ),
  ],
);

/// Landing Page (Welcome screen)
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(title: 'MindSnap'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to MindSnap 👋"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
