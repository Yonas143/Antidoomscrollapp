// lib/features/admin/presentation/user_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart'; // Where userControllerProvider is likely defined
// You might not need to import UserController directly if you only interact via provider
// import '../logic/user_controller.dart';
import '../../../models/user.dart'; // Assuming your User model is here

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider. This will be an AsyncValue<List<User>> if it's asynchronous.
    final AsyncValue<List<User>> usersAsyncValue = ref.watch(userControllerProvider);

    // Use .when to handle the different states of AsyncValue
    return usersAsyncValue.when(
      data: (users) {
        // Data is successfully loaded (users is a List<User>)

        if (users.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No users found.'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true, // Consider if this is truly needed or if the parent handles scrolling
          // physics: const NeverScrollableScrollPhysics(), // Only if inside another scrollable
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index]; // user is an instance of your User model

            // Defensive checks for properties - ensure your User model defines these!
            final String userEmail = user.email ?? 'N/A';
            final String userRole = user.role ?? 'undefined'; // Handle if role can be null
            final String? userId = user.id; // Handle if id can be null

            return ListTile(
              title: Text(userEmail),
              subtitle: Text('Role: $userRole'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userRole != 'admin' && userId != null)
                    IconButton(
                      tooltip: 'Promote User',
                      icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                      onPressed: () {
                        // Show a confirmation dialog before promoting
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Confirm Promotion'),
                            content: Text('Are you sure you want to promote ${userEmail}?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(dialogContext).pop(),
                              ),
                              TextButton(
                                child: const Text('Promote'),
                                onPressed: () {
                                  ref.read(userControllerProvider.notifier).promote(userId);
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  if (userId != null) // Also ensure ID exists for delete
                    IconButton(
                      tooltip: 'Delete User',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete ${userEmail}? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(dialogContext).pop(),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Delete'),
                                onPressed: () {
                                  ref.read(userControllerProvider.notifier).delete(userId);
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading users: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Attempt to reload the data
                  ref.invalidate(userControllerProvider);
                  // Or if your controller has a specific reload method:
                  // ref.read(userControllerProvider.notifier).loadUsers();
                },
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      ),
    );
  }
}