// lib/core/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/dashboard/presentation/user_dashboard.dart';
import '../features/dashboard/presentation/admin_dashboard.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
    GoRoute(path: '/dashboard', builder: (_, __) => const UserDashboard()), // Placeholder
    GoRoute(path: '/admin', builder: (_, __) => const AdminDashboard()), // Placeholder
  ],
);
