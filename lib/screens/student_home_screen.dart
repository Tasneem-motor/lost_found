import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'report_lost_screen.dart';
import 'report_found_screen.dart';
import 'my_reports_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.dashboard,
      title: "Student Dashboard",
      child: Column(
        children: [
          _menuButton(
            context,
            "Report Lost Item",
            Icons.search,
            const ReportLostScreen(),
          ),
          const SizedBox(height: 12),
          _menuButton(
            context,
            "Report Found Item",
            Icons.inventory,
            const ReportFoundScreen(),
          ),
          const SizedBox(height: 12),
          _menuButton(
            context,
            "My Reports",
            Icons.list_alt,
            const MyReportsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(
      BuildContext context, String text, IconData icon, Widget page) {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
