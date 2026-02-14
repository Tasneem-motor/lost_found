import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'student_home_screen.dart';
import 'create_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sapIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 @override
  void initState() {
    super.initState();
  }


  Future<void> loginStudent() async {
     print("Current user: ${FirebaseAuth.instance.currentUser}");
  if (!_formKey.currentState!.validate()) return;

  final sapId = _sapIdController.text.trim();
  final password = _passwordController.text.trim();

  

  final email = "$sapId@sap.yourapp.com";

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!mounted) return;

    // ✅ Login successful
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
    );

  } on FirebaseAuthException catch (e) {
    String errorMessage = "Login failed";

    if (e.code == 'user-not-found') {
      errorMessage = "Account not found. Please create one.";
    } else if (e.code == 'wrong-password') {
      errorMessage = "Incorrect password.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Icon
                    const Icon(
                      Icons.school,
                      size: 70,
                      color: AppColors.turquoise,
                    ),

                    const SizedBox(height: 12),

                    /// Title
                    Text(
                      "Student Login",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 24),

                    /// SAP ID
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        controller: _sapIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        decoration: const InputDecoration(
                          labelText: "SAP ID",
                          counterText: "",
                        ),
                        validator: (value) {
                          if (value == null || value.length != 11) {
                            return "Enter 11-digit SAP ID";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    SizedBox(
                      width: 260,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Enter password" : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Login Button (not full width)
                    SizedBox(
                      width: 180,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: loginStudent,
                        child: const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Create Account
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: const Text("Create New Account"),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
