import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';

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
                    ? "Select Date"
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
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Submit"),
      ),
    );
  }
}
