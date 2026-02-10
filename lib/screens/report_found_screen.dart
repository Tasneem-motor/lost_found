import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';

class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});

  @override
  State<ReportFoundScreen> createState() => _ReportFoundScreenState();
}

class _ReportFoundScreenState extends State<ReportFoundScreen> {
  final _location = TextEditingController();
  bool handedToDept = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return CenterCardLayout(
      icon: Icons.inventory,
      title: "Report Found Item",
      child: Column(
        children: [
          _box(_location, "Found Location"),
          const SizedBox(height: 12),

          /// Image placeholder
          Container(
            width: 260,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text("Image Upload (Optional)"),
            ),
          ),

          const SizedBox(height: 12),

          /// Auto date time
          Text(
            "Date & Time: ${now.day}/${now.month}/${now.year}  ${now.hour}:${now.minute}",
          ),

          const SizedBox(height: 12),

          /// Handed to dept
          SwitchListTile(
            title: const Text("Handed to Department"),
            value: handedToDept,
            onChanged: (v) {
              setState(() => handedToDept = v);
            },
          ),

          const SizedBox(height: 16),

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
