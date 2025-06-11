import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../logic/goal_controller.dart';
import '../../../models/goal.dart';
import 'add_goal_dialog.dart';

class GoalListPage extends ConsumerWidget {
  const GoalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Goals')),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('No goals set yet.'));
          }
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return ListTile(
                title: Text(goal.platform),
                subtitle: Text('Daily Limit: ${goal.dailyLimit} minutes'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(goalControllerProvider.notifier).delete(goal.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddGoalDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
