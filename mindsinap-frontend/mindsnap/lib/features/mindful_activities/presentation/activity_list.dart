// lib/features/mindful_activities/presentation/activity_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/activity_controller.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityControllerProvider);

    return state.when(
      data: (activities) => ListView.builder(
        shrinkWrap: true,
        itemCount: activities.length,
        itemBuilder: (_, i) {
          final activity = activities[i];
          return ListTile(
            title: Text(activity['title']),
            subtitle: Text(activity['description']),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => ref
                  .read(activityControllerProvider.notifier)
                  .delete(activity['id'].toString()),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
