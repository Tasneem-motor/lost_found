import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'report_lost_screen.dart';
import 'report_found_screen.dart';
import 'view_all_reports.dart';
import 'choose_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_reports_screen.dart';



class StudentHomeScreen extends StatelessWidget {
  final String userName;
  final String sapId;

  const StudentHomeScreen({
    super.key,
    required this.userName,
    required this.sapId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Student Dashboard"),
    ),

    // ✅ SIDEBAR
    drawer: Drawer(
      
      child: Column(
        children: [

          // PROFILE HEADER
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF629BB6)
            ),
            accountName: Text(userName),
            accountEmail: Text("SAP ID: $sapId"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Color(0xFFD6EBF3), 
              child: Icon(
                Icons.person,
                size: 35,
                color: Color(0xFF447F98),
              ),
            ),
          ),

          // ✅ MY REPORTS BUTTON
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text("My Reports"),
            onTap: () {
              Navigator.pop(context); // closes drawer first

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyReportsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // LOGOUT BUTTON
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChooseLoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    ),
    // ✅ YOUR EXISTING UI
    body: CenterCardLayout(
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
            "View all Reports",
            Icons.list_alt,
            const ViewAllReports(),
          ),
        ],
      ),
    )
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
