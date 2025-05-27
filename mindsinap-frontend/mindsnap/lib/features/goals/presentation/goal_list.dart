// lib/features/goals/presentation/goal_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/goal_controller.dart';

class GoalList extends ConsumerWidget {
  const GoalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalControllerProvider);

    return state.when(
      data: (goals) => ListView.builder(
        shrinkWrap: true,
        itemCount: goals.length,
        itemBuilder: (_, i) {
          final goal = goals[i];
          return ListTile(
            title: Text(goal['platform']),
            subtitle: Text('Daily limit: ${goal['dailyLimit']} min'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => ref
                  .read(goalControllerProvider.notifier)
                  .delete(goal['id'].toString()),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
