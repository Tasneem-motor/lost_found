import 'package:flutter/material.dart';
import 'my_lost_reports.dart';
import 'my_found_reports.dart';


class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Reports"),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "My lost items"),
              Tab(text: "My found items"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            MyLostReportsScreen(),
            MyFoundReportsScreen(),
          ],
        ),
      ),
    );
  }
}

