// lib/features/admin/presentation/user_list_page.dart

import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: const Center(child: Text('User List Page')),
    );
  }
}
