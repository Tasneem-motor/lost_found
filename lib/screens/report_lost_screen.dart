import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  DateTime? lostDate;

  Future<void> submitLostReport() async {

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  if (_title.text.isEmpty ||
      _desc.text.isEmpty ||
      _location.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields and select image")),
    );
    return;
  }

  // 🔹 fetch student info
  final query = await FirebaseFirestore.instance
      .collection('students')
      .where('uid', isEqualTo: user.uid)
      .get();

  final student = query.docs.first.data();

  await FirebaseFirestore.instance
      .collection('lost_reports')
      .add({
    'itemName': _title.text.trim(),
    'description': _desc.text.trim(),
    'location': _location.text.trim(),
    'sapId': student['sapId'],
    'userName': student['name'],
    'uid': user.uid,
    'lost on': lostDate,
    'resolved': false,
    'createdAt': FieldValue.serverTimestamp(),
  });

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Lost item reported successfully")),
  );

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return CenterCardLayout(
      icon: Icons.search_off,
      title: "Report Lost Item",
      child: Column(
        children: [
          _box(_title, "Item Name"),
          const SizedBox(height: 12),
          _box(_desc, "Description"),
          const SizedBox(height: 12),
          _box(_location, "Possible Location (Optional)"),
          const SizedBox(height: 12),

          /// Date Picker
          SizedBox(
            width: 260,
            child: OutlinedButton(
              onPressed: () async {
                lostDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now(),
                );
                setState(() {});
              },
              child: Text(
                lostDate == null
                    ? "Date Lost (Optional)"
                    : "${lostDate!.day}/${lostDate!.month}/${lostDate!.year}",
              ),
            ),
          ),

          const SizedBox(height: 20),

          _submitButton(),
        ],
      ),
    );
  }

  Widget _box(TextEditingController c, String label) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: c,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton(
        onPressed: submitLostReport,
        child: const Text("Submit"),
      ),
    );
  }
}
