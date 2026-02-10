import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sapId = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.person_add,
      title: "Create Account",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _inputBox(
              controller: _sapId,
              label: "SAP ID",
              maxLength: 11,
              isNumber: true,
            ),
            const SizedBox(height: 14),
            _inputBox(
              controller: _password,
              label: "Password",
              isPassword: true,
            ),
            const SizedBox(height: 14),
            _inputBox(
              controller: _confirmPassword,
              label: "Confirm Password",
              isPassword: true,
            ),
            const SizedBox(height: 24),
            _button("Create Account"),
          ],
        ),
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isNumber = false,
    int? maxLength,
  }) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        decoration: InputDecoration(labelText: label, counterText: ""),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _button(String text) {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context);
          }
        },
        child: Text(text),
      ),
    );
  }
}
