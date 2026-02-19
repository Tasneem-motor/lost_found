import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'report_lost_screen.dart';
import 'report_found_screen.dart';
import 'my_reports_screen.dart';
import 'choose_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
            accountName: Text(userName),
            accountEmail: Text("SAP ID: $sapId"),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 35),
            ),
          ),

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
            "My Reports",
            Icons.list_alt,
            const MyReportsScreen(),
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
