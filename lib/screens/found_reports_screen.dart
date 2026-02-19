import 'package:flutter/material.dart';

class FoundReportsScreen extends StatelessWidget {
  const FoundReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Found Reports")),
      body: const Center(child: Text("Found reports will appear here")),
    );
  }
}
