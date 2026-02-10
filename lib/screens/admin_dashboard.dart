import 'package:flutter/material.dart';
import '../models/data_store.dart';
import '../models/report.dart';
import '../widgets/center_card_layout.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.admin_panel_settings,
      title: "Admin Dashboard",
      child: SizedBox(
        width: 320,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: DataStore.reports.length,
          itemBuilder: (context, index) {
            final report = DataStore.reports[index];
            return _reportCard(report);
          },
        ),
      ),
    );
  }

  Widget _reportCard(Report report) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${report.type} Item",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Title: ${report.title}"),
            Text("Report ID: ${report.reportId}"),

            const SizedBox(height: 8),

            CheckboxListTile(
              title: const Text("Received by Department"),
              value: report.received,
              onChanged: (v) {
                setState(() => report.received = v!);
              },
            ),

            CheckboxListTile(
              title: const Text("Claimed"),
              value: report.claimed,
              onChanged: report.received
                  ? (v) {
                _claimDialog(report);
              }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _claimDialog(Report report) {
    final ownerController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Mark as Claimed"),
        content: TextField(
          controller: ownerController,
          decoration: const InputDecoration(
            labelText: "Owner SAP ID",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                report.claimed = true;
                report.ownerSapId = ownerController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
