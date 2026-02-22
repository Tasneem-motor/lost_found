import 'package:flutter/material.dart';
import 'lost_reports_screen.dart';
import 'found_reports_screen.dart';
import "analytics_screen.dart";

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                child: const Text('View Lost Reports'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LostReportsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                child: const Text('View Found Reports'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FoundReportsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),


             SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                child: const Text('View Analytics'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnalyticsScreen(),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
