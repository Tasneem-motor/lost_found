import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'student_login_screen.dart';
import 'admin_login_screen.dart';


class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.search,
      title: "Campus Lost & Found",
      child: Column(
        children: [
          _button(
            context,
            text: "Student / User Login",
            icon: Icons.school,
            screen: const StudentLoginScreen(),
          ),
          const SizedBox(height: 16),
          _button(
            context,
            text: "Admin Login",
            icon: Icons.admin_panel_settings,
            screen: const AdminLoginScreen(),
          ),
        ],
      ),
    );
  }

  Widget _button(BuildContext context,
      {required String text,
        required IconData icon,
        required Widget screen}) {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }
}
