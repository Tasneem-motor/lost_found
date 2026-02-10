import 'package:flutter/material.dart';
import '../models/data_store.dart';
import '../theme/app_colors.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reports"),
      ),
      body: DataStore.reports.isEmpty
          ? const Center(
        child: Text(
          "No reports submitted yet",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DataStore.reports.length,
        itemBuilder: (context, index) {
          final report = DataStore.reports[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    report.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),

                  /// Type
                  Text(
                    "Type: ${report.type}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 8),

                  /// Report ID
                  Text(
                    "Report ID: ${report.reportId}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 12),

                  /// Status Chip
                  Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(
                        report.claimed ? "Claimed" : "Pending",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: report.claimed
                          ? Colors.green
                          : AppColors.slateBlue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
