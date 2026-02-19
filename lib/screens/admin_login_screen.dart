import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'admin_home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.admin_panel_settings,
      title: "Admin Login",
      child: Column(
        children: [
          _box(_user, "Username"),
          const SizedBox(height: 16),
          _box(_pass, "Password", isPassword: true),
          const SizedBox(height: 24),
          _button(
            "Login",
                () {
              if (_user.text == "admin" && _pass.text == "admin123") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>  AdminHomeScreen()),
                );
              }else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid credentials")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
void dispose() {
  _user.dispose();
  _pass.dispose();
  super.dispose();
}


  Widget _box(TextEditingController c, String l,
      {bool isPassword = false}) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: c,
        obscureText: isPassword,
        decoration: InputDecoration(labelText: l),
      ),
    );
  }

  Widget _button(String t, VoidCallback onTap) {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton(onPressed: onTap, child: Text(t)),
    );
  }
}
