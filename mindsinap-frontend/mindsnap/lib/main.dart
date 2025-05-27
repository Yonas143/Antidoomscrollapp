// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';

void main() {
  runApp(const ProviderScope(child: MindSnapApp()));
}

class MindSnapApp extends StatelessWidget {
  const MindSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MindSnap',
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
