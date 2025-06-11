import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key}); // Ensure it has a const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: const Center(
        child: Text('Admin: User List will be here.'),
      ),
    );
  }
}