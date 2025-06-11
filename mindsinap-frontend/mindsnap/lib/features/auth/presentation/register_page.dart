// lib/features/auth/presentation/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import '../../../core/providers.dart';
import '../logic/auth_state.dart';
// Import your AuthState if you need to listen to specific properties like error directly
// import '../logic/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key}); // Use super.key

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = ''; // Add name field
  String _username = ''; // Or email, depending on your backend
  String _password = '';
  bool _isMounted = false; // To handle async operations safely

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save(); // Ensure onSaved is called if you use it

      // Call the register method from your AuthController
      // Ensure your AuthController.register method is updated to accept 'name'
      // and that it sets isLoading and handles the auth state correctly.
      // GoRouter's redirect logic will handle navigation based on AuthState changes.
      await ref.read(authControllerProvider.notifier).register(
        name: _name, // Pass the name
        email: _username, // Assuming username is email, adjust if not
        password: _password,
      );

      // No direct navigation here. GoRouter's redirect will handle it.
      // Check for errors *after* the operation, if needed for UI feedback
      // This is often better handled by listening to authState.error in the build method
      // or using a ref.listen for one-time events like snackbars.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors to show a SnackBar (optional, good UX)
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (_isMounted && next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        // Optionally clear the error in AuthController after showing it
        // ref.read(authControllerProvider.notifier).clearError();
      }
    });

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center( // Center the content
        child: SingleChildScrollView( // Allow scrolling for smaller screens
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center column content
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons
              children: [
                Text(
                  'Join MindSnap',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (val) => _name = val.trim(),
                  onSaved: (val) => _name = val?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    // Decide if this is 'Username' or 'Email' based on your backend
                    labelText: 'Email', // Assuming it's an email
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (val) => _username = val.trim(),
                  onSaved: (val) => _username = val?.trim() ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (val) => _password = val,
                  onSaved: (val) => _password = val ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  // Disable button while loading
                  onPressed: authState.isLoading ? null : _submitRegister,
                  child: authState.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Register'),
                ),
                // The general error display is removed here because the SnackBar handles it.
                // If you still want a persistent error message in the UI:
                // if (authState.error != null && !authState.isLoading)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 8.0),
                //     child: Text(
                //       authState.error!,
                //       style: const TextStyle(color: Colors.red),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                    // Use GoRouter for navigation
                    context.go('/login');
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}