import 'package:flutter/material.dart';
import 'report_lost_screen.dart';
import 'report_found_screen.dart';
import 'my_reports_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportLostScreen()));
              },
              child: const Text("Report Lost Item"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportFoundScreen()));
              },
              child: const Text("Report Found Item"),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MyReportsScreen()));
              },
              child: const Text("My Reports"),
            ),
          ],
        ),
      ),
    );
  }
}
