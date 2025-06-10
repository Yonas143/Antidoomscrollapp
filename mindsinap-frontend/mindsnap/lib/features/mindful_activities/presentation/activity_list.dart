import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../models/activity.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Activities')),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.title),
            subtitle: Text(activity.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref
                    .read(activityControllerProvider.notifier)
                    .delete(activity.id);
              },
            ),
          );
        },
      ),
    );
  }
}
