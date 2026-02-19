import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sapId = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

Future<void> createAccount() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

  if (_password.text != _confirmPassword.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  final name = _name.text.trim();
  final sapId = _sapId.text.trim();
  final password = _password.text.trim();

  final email = "$sapId@sap.yourapp.com";

  try {
    //  Check if SAP ID already exists in Firestore
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(sapId)
        .get();

    if (doc.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account already exists")),
      );
      return;
    }

    //  Create Firebase Auth user
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save student data in Firestore
    await FirebaseFirestore.instance
        .collection('students')
        .doc(sapId)
        .set({
      'name': name,
      'sapId': sapId,
      'uid': userCredential.user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    

    if (!mounted) return;

    

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created successfully")),
    );
    Navigator.pop(context); // go back to login

    

  } on FirebaseAuthException catch (e) {
    String msg = "Account creation failed";

    if (e.code == 'email-already-in-use') {
      msg = "Account already exists";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );

  }

}




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
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (!RegExp(r'^\d{11}$').hasMatch(v)) {
                  return "Enter valid 11-digit SAP ID";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _inputBox(
              controller: _name,
              label: "Full Name",
            ),
            

            const SizedBox(height: 14),
            _inputBox(
              controller: _password,
              label: "Password",
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (v.length < 6) return "Minimum 6 characters";
                return null;
              },
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
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        decoration: InputDecoration(labelText: label, counterText: ""),
        validator:
            validator ?? (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _button(String text) {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton(
        onPressed: createAccount,
        child: Text(text),
      ),
    );
  }

  @override
void dispose() {
  _sapId.dispose();
  _name.dispose();
  _password.dispose();
  _confirmPassword.dispose();
  super.dispose();
}
}


