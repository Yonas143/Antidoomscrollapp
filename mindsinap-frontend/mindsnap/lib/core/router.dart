// lib/core/router.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindsnap/core/providers.dart';

// Import all your page widgets
import 'package:mindsnap/features/auth/presentation/splash_page.dart'; // Keep for initialLocation if desired, or remove
import 'package:mindsnap/features/dashboard/presentation/user_dashboard.dart';
import 'package:mindsnap/features/dashboard/presentation/admin_dashboard.dart';
import 'package:mindsnap/features/auth/presentation/login_page.dart';
import 'package:mindsnap/features/auth/presentation/register_page.dart';
// Make sure this is imported
import 'package:mindsnap/features/mindful_activities/presentation/activity_list_page.dart';
import 'package:mindsnap/features/mindful_activities/presentation/activity_form_page.dart';
import 'package:mindsnap/features/goals/presentation/goal_list_page.dart';
import 'package:mindsnap/features/goals/presentation/goal_form_page.dart';
import 'package:mindsnap/features/admin/presentation/user_list_page.dart' as admin_user_list;

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
    print("GoRouterRefreshStream disposed");
  }
}

final goRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final authNotifier = ref.watch(authControllerProvider.notifier);
  final refreshNotifier = GoRouterRefreshStream(authNotifier.stream);
  ref.onDispose(refreshNotifier.dispose);

  // Decide on your true initial location if not a dedicated splash screen
  // If AuthController's _checkInitialAuth() is quick, you might start at '/'
  // If it can take time, starting at '/splash' (even if it's brief) can be okay,
  // or your LandingPage needs to handle a loading state gracefully.
  String getInitialLocation() {
    if (authState.isLoading && authState.user == null) { // Still checking initial auth
      return '/splash'; // Or directly '/' if your LandingPage shows a loader
    }
    if (authState.user != null && authState.token != null) {
      return '/dashboard/user';
    }
    return '/'; // Default to landing page
  }

  return GoRouter(
    initialLocation: getInitialLocation(), // Dynamic initial location
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: '/splash', // You can keep this route if LandingPage or other pages might need a moment to decide
        builder: (context, state) => const SplashPage(), // Or replace with a minimal loading widget
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard/user',
        name: 'userDashboard',
        builder: (context, state) => const UserDashboard(),
      ),
      GoRoute(
        path: '/dashboard/admin',
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/activities',
        name: 'activities',
        builder: (context, state) => const ActivityListPage(),
      ),
      GoRoute(
        path: '/activities/new',
        name: 'newActivity',
        builder: (context, state) => const ActivityFormPage(),
      ),
      GoRoute(
        path: '/goals',
        name: 'goals',
        builder: (context, state) => const GoalListPage(),
      ),
      GoRoute(
        path: '/goals/new',
        name: 'newGoal',
        builder: (context, state) => const GoalFormPage(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'adminUsers',
        builder: (context, state) => admin_user_list.UserListPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState goRouterState) {
      final currentLoc = goRouterState.matchedLocation;
      final isUserLoggedIn = authState.user != null && authState.token != null;
      final isAuthProcessing = authState.isLoading; // Still useful for logic, just not for forced splash redirect

      print(
          "🔄 GO_ROUTER REDIRECT: Loc: $currentLoc, IsLoggedIn: $isUserLoggedIn, IsAuthProcessing: $isAuthProcessing (User: ${authState.user?.id}, Token: ${authState.token != null ? 'present' : 'absent'})");

      final publicOnlyRoutes = ['/', '/login', '/register'];
      final isOnPublicOnlyRoute = publicOnlyRoutes.contains(currentLoc);
      final isOnSplash = currentLoc == '/splash'; // Keep for initial load logic if SplashPage is used as initialLocation

      // If initial auth check is happening AND we are on splash, stay on splash.
      // This prevents redirecting away from splash too early if splash is the initialLocation
      // and AuthController is still running its initial check.
      if (isOnSplash && isAuthProcessing && authState.user == null) {
        print("    Decision: Initial auth processing on splash. Staying on /splash.");
        return null; // Stay on splash while initial check completes
      }

      // If auth is processing (e.g., during login API call) but we're NOT on splash,
      // we DON'T automatically redirect to splash. The current page should show its own loader.
      if (isAuthProcessing && !isOnSplash) {
        print("    Decision: Auth is processing (e.g. login API call) on $currentLoc. Staying on current page.");
        return null; // Stay on current page (e.g., LoginPage), expect it to show a loader
      }

      // At this point, authState.isLoading should ideally be false,
      // OR we are on a page that handles its own loading state.

      // --- Logged-in User ---
      if (isUserLoggedIn) {
        print("    Decision: User IS logged in. Current: $currentLoc");
        if (isOnSplash || isOnPublicOnlyRoute) {
          print("        Redirecting logged-in user from $currentLoc to /dashboard/user");
          return '/dashboard/user';
        }
        print("        Allowing navigation to $currentLoc for logged-in user.");
        return null; // Already on a protected route or intended page
      }

      // --- Logged-OUT User (and auth processing is finished or handled by the page) ---
      print("    Decision: User is NOT logged in. Current: $currentLoc");
      if (isOnSplash) { // Finished initial auth check (isAuthProcessing is false OR user is null after check)
        print("        Finished splash/initial check, user not logged in. Redirecting from /splash to /");
        return '/';
      }

      // If not logged in and trying to access a protected route (not splash, not public-only)
      if (!isOnPublicOnlyRoute && !isOnSplash) {
        print("        User not logged in, on protected route $currentLoc. Redirecting to /");
        return '/';
      }

      // If not logged in, and on a public-only route (and not splash), allow.
      print("        Allowing navigation to public route $currentLoc for logged-out user.");
      return null;
    },
  );
});

// Remove the placeholder SplashPage definition at the bottom if you are not using it at all
// OR keep it if '/splash' is still your initialLocation and you want a visual for that brief moment.
// If you remove the SplashPage class, also remove its import.

// Placeholder for SplashPage - consider if this is still needed
// If your initialLocation is '/', this might not be built often.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    print("Building SplashPage UI (if used for initial brief load)");
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent))), // Minimal
    );
  }
}

// Placeholder for LandingPage if not imported
class LandingPage extends ConsumerWidget { // Made ConsumerWidget to potentially read authState for its own loading
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optional: LandingPage can also show a loading indicator if authState.isLoading is true
    // final authState = ref.watch(authControllerProvider);
    // if (authState.isLoading && authState.user == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    print("Building LandingPage UI");
    return Scaffold(
      appBar: AppBar(title: const Text('MindSnap Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to MindSnap! 👋"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print("LandingPage: Go to Login button pressed");
                // Potentially show loading indicator on LoginPage itself
                context.go('/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("LandingPage: Go to Register button pressed");
                // Potentially show loading indicator on RegisterPage itself
                context.go('/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}