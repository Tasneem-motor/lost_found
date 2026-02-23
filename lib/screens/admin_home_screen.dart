import 'package:flutter/material.dart';
import 'lost_reports_screen.dart';
import 'found_reports_screen.dart';
import "analytics_screen.dart";
import 'choose_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        centerTitle: true,
      ),

      drawer: Drawer(
      
      child: Column(
        children: [

          // PROFILE HEADER
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF629BB6)
            ),
            accountName: Text("Admin"),
            accountEmail: Text("Department in-charge"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Color(0xFFD6EBF3), 
              child: Icon(
                Icons.person,
                size: 35,
                color: Color(0xFF447F98),
              ),
            ),
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
