import 'package:flutter/material.dart';
import 'view_lost_reports.dart';
import 'view_found_reports.dart';


class ViewAllReports extends StatelessWidget {
  const ViewAllReports({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("View All Reports"),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Lost Item's Reports"),
              Tab(text: "Found Item's Reports"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ViewLostReportsScreen(),
            ViewFoundReportsScreen(),
          ],
        ),
      ),
    );
  }
}

