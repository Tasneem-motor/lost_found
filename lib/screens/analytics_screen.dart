import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {

  int resolvedLost = 0;
  int unresolvedLost = 0;
  int claimedFound = 0;
  int unclaimedFound = 0;
  int handedToDept = 0;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  final List<String> months = const [
    "January", "February", "March", "April",
    "May", "June", "July", "August",
    "September", "October", "November", "December"
  ];

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    // LOST REPORTS
    final lostSnapshot =
        await FirebaseFirestore.instance.collection('lost_reports').get();

    for (var doc in lostSnapshot.docs) {
      final data = doc.data();

      if (data['timestamp'] != null) {
        final DateTime date =
            (data['timestamp'] as Timestamp).toDate();

        if (date.month != selectedMonth ||
            date.year != selectedYear) {
          continue; // Skip if not selected month
        }
      }

      final resolved = data['resolved'] ?? false;

      if (resolved) {
        resolvedLost++;
      } else {
        unresolvedLost++;
      }
    }

    // FOUND REPORTS
    final foundSnapshot =
        await FirebaseFirestore.instance.collection('found_reports').get();

    for (var doc in foundSnapshot.docs) {
      final data = doc.data();

    if (data['timestamp'] != null) {
        final DateTime date =
            (data['timestamp'] as Timestamp).toDate();

        if (date.month != selectedMonth ||
            date.year != selectedYear) {
          continue; // Skip if not selected month
        }
      }


      final claimed = data['claimed'] ?? false;

      if (claimed) {
        claimedFound++;
      } else {
        unclaimedFound++;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics Dashboard"),
      ),
      body: Column(
        children: [

          const SizedBox(height: 14),

          // 🔹 FIXED MONTH FILTER (Not Scrollable, No Card)
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButton<int>(
              value: selectedMonth,
              isExpanded: true,
              underline: Container(),
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(months[index]),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 14),

          // 🔥 SCROLLABLE CHARTS
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  buildChartCard(
                    title: "Overview of Reports",
                    chart: buildOverviewPieChart(),
                    legendItems: [
                      legendItem(Colors.red, "Lost & unresolved"),
                      legendItem(Colors.green, "Lost but resolved"),
                      legendItem(Colors.blue, "Found & Claimed"),
                      legendItem(Colors.orange, "Found but not handed to dept."),
                      legendItem(Colors.purple, "Found & handed to dept. but unclaimed"),
                    ],
                  ),

                  const SizedBox(height: 50),

                  buildChartCard(
                    title: "Lost Reports Overview",
                    chart: buildLostPieChart(),
                    legendItems: [
                      legendItem(Colors.green, "Resolved"),
                      legendItem(Colors.red, "Unresolved"),
                    ],
                  ),

                  const SizedBox(height: 50),

                  buildChartCard(
                    title: "Found Reports Overview",
                    chart: buildFoundPieChart(),
                    legendItems: [
                      legendItem(Colors.blue, "Claimed"),
                      legendItem(Colors.orange, "Unclaimed"),
                      legendItem(Colors.purple, "Unclaimed but handed to dept."),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Reusable Chart Card
  Widget buildChartCard({
  required String title,
  required Widget chart,
  required List<Widget> legendItems,
}) {
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: chart,
          ),

          const SizedBox(height: 20),

          // 🔹 Legend bottom-right
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: legendItems,
            ),
          ),
        ],
      ),
    ),
  );
}

  // 🔹 OVERVIEW PIE
  Widget buildOverviewPieChart() {
    final total = resolvedLost +
        unresolvedLost +
        claimedFound +
        unclaimedFound +
        handedToDept;

    if (total == 0) {
      return const Center(child: Text("No data available"));
    }

    return SizedBox( 
      height: 300,
      child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  value: resolvedLost.toDouble(),
                  color: Colors.green,
                  radius: 100,
                  title: "${(( resolvedLost / total) * 100).toStringAsFixed(0)}%",
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: unresolvedLost.toDouble(),
                  color: Colors.red,
                  radius: 100,
                  title: "${(( unresolvedLost / total) * 100).toStringAsFixed(0)}%",
                ),
                PieChartSectionData(
                  value: claimedFound.toDouble(),
                  color: Colors.blue,
                  radius: 100,
                  title: "${(( claimedFound / total) * 100).toStringAsFixed(0)}%",
                ),
                PieChartSectionData(
                  value: unclaimedFound.toDouble(),
                  color: Colors.orange,
                  radius: 100,
                  title: "${(( unclaimedFound / total) * 100).toStringAsFixed(0)}%",
                ),
                PieChartSectionData(
                  value: handedToDept.toDouble(),
                  color: Colors.purple,
                  radius: 100,
                  title: "${(( handedToDept / total) * 100).toStringAsFixed(0)}%",
                ),
              ],
            ),
          )
    );
  }

  // 🔹 LOST PIE
  Widget buildLostPieChart() {
    final total = resolvedLost + unresolvedLost;

    if (total == 0) {
      return const Center(child: Text("No lost reports"));
    }

    return SizedBox( 
      height: 300,
      child:  PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            value: resolvedLost.toDouble(),
            color: Colors.green,
            radius: 100,
            title: "${(( resolvedLost / total) * 100).toStringAsFixed(0)}%",
          ),
          PieChartSectionData(
            value: unresolvedLost.toDouble(),
            color: Colors.red,
            radius: 100,
            title: "${(( unresolvedLost / total) * 100).toStringAsFixed(0)}%",
          ),
        ],
      ),
    ));
  }

  // 🔹 FOUND PIE
  Widget buildFoundPieChart() {
    final total = claimedFound + unclaimedFound + handedToDept;

    if (total == 0) {
      return const Center(child: Text("No found reports"));
    }

    return SizedBox( 
      height: 300,
      child:  PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            value: claimedFound.toDouble(),
            color: Colors.blue,
            radius: 100,
            title: "${(( claimedFound / total) * 100).toStringAsFixed(0)}%",
          ),
          PieChartSectionData(
            value: unclaimedFound.toDouble(),
            color: Colors.orange,
            radius: 100,
            title: "${(( unclaimedFound / total) * 100).toStringAsFixed(0)}%",
          ),
          PieChartSectionData(
            value: handedToDept.toDouble(),
            color: Colors.purple,
            radius: 100,
            title: "${(( handedToDept / total) * 100).toStringAsFixed(0)}%",
          ),
        ],
      ),
    ));
  }
  Widget legendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}