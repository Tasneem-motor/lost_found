import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';



class FoundReportsScreen extends StatelessWidget {
  FoundReportsScreen({super.key});

  final CollectionReference foundReports =
      FirebaseFirestore.instance.collection('found_reports');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Found Reports"),
        centerTitle: true,
      ),
      
      body: StreamBuilder<QuerySnapshot>(
        stream: foundReports
        .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No found reports available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {

              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final claimed = data['claimed'] ?? false;
              final received = data['received'] ?? false;

              // 🔹 Date conversion
              final timestamp = data['timestamp'] as Timestamp?;
              final date = timestamp?.toDate();

              final formattedDate = date != null
                  ? "${date.day}-${date.month}-${date.year}"
                  : "No Date";

              String? base64Image = data['image'];

              Uint8List? imageBytes;

              if (base64Image != null && base64Image.isNotEmpty) {
                imageBytes = base64Decode(base64Image);
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        data['title'] ?? 'No Title',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      const SizedBox(height: 6),

                      Text("Description: ${data['description'] ?? ''}"),
                      Text("Location: ${data['location'] ?? ''}"),
                      Text("Found on: $formattedDate"),
                      Text("Handed to department ? ${data['handedToDept'] ?? ''}"),
                      const SizedBox(height: 10),

                       if (imageBytes != null)
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      imageBytes!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF447F98),
                        ),
                        icon: const Icon(Icons.visibility),
                        label: const Text("View Image"),
                      ),


                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Received by Department",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),

                          Switch(
                            value: received,
                            activeColor: Colors.green,
                            onChanged: (value) async {
                              await FirebaseFirestore.instance
                                  .collection('found_reports')
                                  .doc(doc.id)
                                  .update({'received': value});
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          received
                              ? "✓ Marked as received"
                              : "✕ Not yet received",
                          style: TextStyle(
                            color: received ? Colors.green[700] : Colors.red[700],
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Claimed by Owner",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),

                          Switch(
                            value: claimed,
                            activeColor: Colors.blue,
                            onChanged: (value) async {
                              await FirebaseFirestore.instance
                                  .collection('found_reports')
                                  .doc(doc.id)
                                  .update({'claimed': value});
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          claimed
                              ? "✓ Marked as claimed"
                              : "✕ Not yet claimed",
                          style: TextStyle(
                            color: claimed ? Colors.blue[700] : Colors.red[700],
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ),



                      // 🔴 Delete Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Report"),
                                content: const Text(
                            "Are you sure you want to delete this report?\n\nThis action cannot be undone.\n\nReport once deleted cannot be restored by any means"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('found_reports')
                                          .doc(doc.id)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}