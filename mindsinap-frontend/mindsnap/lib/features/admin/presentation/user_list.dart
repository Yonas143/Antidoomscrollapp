// lib/features/admin/presentation/user_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../logic/user_controller.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userControllerProvider);

    if (users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (_, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.email ?? 'N/A'),
          subtitle: Text('Role: ${user.role}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user.role != 'admin')
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                  onPressed: () => ref
                      .read(userControllerProvider.notifier)
                      .promote(user.id),
                ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => ref
                    .read(userControllerProvider.notifier)
                    .delete(user.id),
              ),
            ],
          ),
        );
      },
    );
  }

}
