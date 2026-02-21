import 'package:flutter/material.dart';
import '../widgets/center_card_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';



class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});

  @override
  State<ReportFoundScreen> createState() => _ReportFoundScreenState();
}

class _ReportFoundScreenState extends State<ReportFoundScreen> {
  final _location = TextEditingController();
  final _title = TextEditingController();
  final _desc = TextEditingController();

  String? handedToDept;
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  Future<void> pickImage(ImageSource source) async {
  final picked = await picker.pickImage(
    source: source,
    imageQuality: 50,   
    maxWidth: 1000,     
    maxHeight: 1000,    
  );

  if (picked != null) {
    setState(() {
      selectedImage = File(picked.path);
    });
  }
}


Future<void> submitFoundItem() async {

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  if (_title.text.isEmpty ||
      _desc.text.isEmpty ||
      _location.text.isEmpty ||
      selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields and select image")),
    );
    return;
  }

  // 🔹 Convert compressed image to bytes
  final bytes = await selectedImage!.readAsBytes();

  // 🔹 Convert to base64
  String base64Image = base64Encode(bytes);

  if (base64Image.length > 1000000) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Image too large. Try another photo.")),
  );
  return;
}
  final query = await FirebaseFirestore.instance
      .collection('students')
      .where('uid', isEqualTo: user.uid)
      .get();

  final student = query.docs.first.data();


  // 🔹 Save to Firestore
  await firestore.collection("found_reports").add({
    "title": _title.text,
    "description": _desc.text,
    "location": _location.text,
    "sapId": student['sapId'],
    "userName": student['name'],
    "handedToDept": handedToDept ?? "No",
    "claimed": false,
    "image": base64Image,
    "received" : false,
    "timestamp": FieldValue.serverTimestamp(),
    'uid': user.uid,
  });

  if (!context.mounted) return;


  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Item reported successfully")),
  );

  Navigator.pop(context);

  _title.clear();
  _desc.clear();
  _location.clear();

  setState(() {
    selectedImage = null;
    handedToDept = null;
  });
}




  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return CenterCardLayout(
      icon: Icons.inventory,
      title: "Report Found Item",
      child: Column(
        children: [
          _box(_title, "Item Name"),
          const SizedBox(height: 12),
          _box(_desc, "Description"),
          const SizedBox(height: 12),
          _box(_location, "Found Location"),
          const SizedBox(height: 12),

          /// Image placeholder
          GestureDetector(
  onTap: () {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take Photo"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  },
  child: Container(
    width: 260,
    height: 120,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(12),
    ),
    child: selectedImage == null
        ? const Center(child: Text("Tap to Upload Image"))
        : Image.file(selectedImage!, fit: BoxFit.cover),
  ),
),

          const SizedBox(height: 12),

          /// Auto date time
          Text(
            "Date & Time: ${now.day}/${now.month}/${now.year}  ${now.hour}:${now.minute}",
          ),

          const SizedBox(height: 12),

          /// Handed to dept
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    const Text(
      "Handed to Department?",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),

    RadioGroup<String>(
      groupValue: handedToDept,
      onChanged: (value) {
        setState(() {
          handedToDept = value;
        });
      },
      child: Column(
        children: [

          RadioListTile<String>(
            title: const Text("No"),
            value: "No",
          ),

          RadioListTile<String>(
            title: const Text("Yes"),
            value: "Yes",
          ),

        ],
      ),
    ),

  ],
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
        onPressed: submitFoundItem,
        child: const Text("Submit"),
      ),
    );
  }
}

