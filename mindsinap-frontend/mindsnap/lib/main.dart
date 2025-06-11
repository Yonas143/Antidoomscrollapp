import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsnap/core/router.dart'; // Your router provider file

void main() {
  runApp(
    const ProviderScope( // Ensures Riverpod is available
      child: MindSnapApp(), // Changed class name for clarity
    ),
  );
}

class MindSnapApp extends ConsumerWidget { // Make it a ConsumerWidget
  const MindSnapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef
    final router = ref.watch(goRouterProvider); // <-- WATCH the provider

    return MaterialApp.router(
      title: 'MindSnap',
      debugShowCheckedModeBanner: false,
      routerConfig: router, // <-- Use the router instance from the provider
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //brightness: Brightness.dark, // Example theme customization
      ),
    );
  }
}