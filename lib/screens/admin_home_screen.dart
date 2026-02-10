import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('View All Reports'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  AdminDashboard()),
            );
          },
        ),
      ),
    );
  }
}
