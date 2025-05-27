// lib/features/admin/presentation/user_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/user_controller.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userControllerProvider);

    return users.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (_, index) {
          final user = data[index];
          return ListTile(
            title: Text(user['email'] ?? 'N/A'),
            subtitle: Text('Role: ${user['role']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user['role'] != 'admin')
                  IconButton(
                    icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                    onPressed: () => ref
                        .read(userControllerProvider.notifier)
                        .promote(user['id'].toString()),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => ref
                      .read(userControllerProvider.notifier)
                      .delete(user['id'].toString()),
                ),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
