// lib/core/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/dashboard/presentation/user_dashboard.dart';
import '../features/dashboard/presentation/admin_dashboard.dart';
import '../features/admin/presentation/user_list.dart';
import '../features/mindful_activities/presentation/activity_list.dart';
import '../features/goals/presentation/goal_list.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
    GoRoute(path: '/dashboard', builder: (_, __) => const UserDashboard()),
    GoRoute(path: '/admin', builder: (_, __) => const AdminDashboard()),
    GoRoute(path: '/admin/users', builder: (_, __) => const UserListPage()),
    GoRoute(path: '/activities', builder: (_, __) => const ActivityListPage()),
    GoRoute(path: '/goals', builder: (_, __) => const GoalListPage()),
  ],
);
