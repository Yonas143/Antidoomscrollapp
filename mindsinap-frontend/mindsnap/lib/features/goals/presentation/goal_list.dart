// lib/features/goals/presentation/goal_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ensure these imports are correct and point to your actual files
import '../../../core/providers.dart';   // Where goalControllerProvider is defined
// Note: You usually don't need to import the GoalController class itself here
// if you're only interacting via the provider and its state/notifier methods.
import '../../../models/goal.dart';     // Your Goal model

class GoalList extends ConsumerWidget {
  const GoalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of the goalControllerProvider.
    // The state is AsyncValue<List<Goal>>.
    final AsyncValue<List<Goal>> goalsAsyncValue = ref.watch(goalControllerProvider);

    // Use .when to handle loading, error, and data states conveniently.
    return goalsAsyncValue.when(
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
                'Error loading goals: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Access the notifier to call methods like loadGoals
                  ref.read(goalControllerProvider.notifier).loadGoals();
                },
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      ),
      data: (goals) {
        // Data is successfully loaded (goals is a List<Goal>)
        if (goals.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No goals found. Add one!'),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true, // If this list is inside another scrollable
          physics: const NeverScrollableScrollPhysics(), // If inside another scrollable
          itemCount: goals.length,
          itemBuilder: (_, index) {
            final goal = goals[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: Text(goal.platform), // Assuming 'platform' is a property of your Goal model
                subtitle: Text('Daily Limit: ${goal.dailyLimit}'), // Assuming 'dailyLimit' is a property
                // Add more details from your Goal model as needed
                // e.g., title: Text(goal.title ?? 'No title'),
                // subtitle: goal.description != null ? Text(goal.description!) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete this goal for "${goal.platform}"?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                // Access the notifier to call the delete method
                                ref.read(goalControllerProvider.notifier).delete(goal.id); // Assuming goal.id exists
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}