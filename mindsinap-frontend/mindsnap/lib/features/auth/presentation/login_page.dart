import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import '../../../core/providers.dart';
import '../logic/auth_state.dart';
// If you create AppRoutes.dart, import it. Otherwise, use string literals.
// import '../../../core/navigation/app_routes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      print('LoginPage Listener: AuthState changed. Prev: $previous, Next: $next');
      final wasLoading = previous?.isLoading ?? false;

      if (wasLoading && !next.isLoading) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (next.user != null && next.token != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! Navigating...'),
              backgroundColor: Colors.green,
            ),
          );
          // *** THIS IS THE KEY CHANGE ***
          // Use the exact path defined in your GoRouter
          context.go('/dashboard/user');
        }
      } else if (next.error != null && !next.isLoading && !wasLoading && previous?.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username or email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Login button pressed. Attempting to login...');
                    ref.read(authControllerProvider.notifier).login(
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  } else {
                    print('Login form is not valid.');
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: authState.isLoading ? null : () {
                  // Navigate to register page using the exact path
                  context.push('/register'); // or context.go('/register');
                },
                child: const Text('Don\'t have an account? Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}