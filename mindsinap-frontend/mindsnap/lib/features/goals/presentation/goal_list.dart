// lib/features/goals/presentation/goal_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../models/goal.dart';

class GoalList extends ConsumerWidget {
  const GoalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalControllerProvider);

    if (goals.isEmpty) {
      return const Center(child: Text('No goals found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: goals.length,
      itemBuilder: (_, index) {
        final goal = goals[index];
        return ListTile(
          title: Text(goal.title),
          subtitle: Text(goal.description),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => ref
                .read(goalControllerProvider.notifier)
                .delete(goal.id),
          ),
        );
      },
    );
  }
}
