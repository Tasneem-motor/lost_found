import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lost & Found App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        centerTitle: true,
      ),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLoginScreen(),
                  ),
                );
              },
              child: const Text('User Login'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Admin Login'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      )
    );
  }
}
class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Sap ID',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserHomeScreen(),
                  ),
                );
              },
              child: const Text('Login'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSignupScreen(),
                  ),
                );
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
class UserSignupScreen extends StatelessWidget {
  const UserSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Sap ID',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Name (as per ID)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Set Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportLostItemScreen(),
                  ),
                );
              },
              child: const Text('Report Lost Item'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportFoundItemScreen(),
                  ),
                );
              },
              child: const Text('Report Found Item'),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // go to view found items later
              },
              child: const Text('View Found Items'),
            ),
          ],
        ),
      ),
    );
  }
}
class ReportLostItemScreen extends StatelessWidget {
  const ReportLostItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Your Lost Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Name / Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Short Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Date Lost (DD/MM/YYYY)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Possible Location (Optional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // submit logic later
              },
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
class ReportFoundItemScreen extends StatefulWidget {
  const ReportFoundItemScreen({super.key});

  @override
  State<ReportFoundItemScreen> createState() =>
      _ReportFoundItemScreenState();
}

class _ReportFoundItemScreenState extends State<ReportFoundItemScreen> {
  String handedToDept = 'no';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Found Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Location Found',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Item Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                // image picker later
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Upload Image'),
            ),

            const SizedBox(height: 16),

            Text(
              'Date & Time: ${DateTime.now().toString().substring(0, 16)}',
            ),

            const SizedBox(height: 16),

            const Text(
              'Handed Over to Department?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            
            RadioGroup<String>(
              groupValue: handedToDept,
              onChanged: (value) {
                setState(() {
                  handedToDept = value!;
                });
              },
              child: Column(
                children: const [
                  RadioListTile<String>(
                    title: Text('Yes'),
                    value: 'yes',
                  ),
                  RadioListTile<String>(
                    title: Text('No'),
                    value: 'no',
                  ),
                ],
              ),
            ),




            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // submit logic later
              },
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
