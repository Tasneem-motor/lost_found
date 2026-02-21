import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class ViewFoundReportsScreen extends StatelessWidget {
  ViewFoundReportsScreen({super.key});

  final CollectionReference lostReports =
      FirebaseFirestore.instance.collection('found_reports');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: lostReports
        .where('claimed', isEqualTo: false)
        .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Found item's reports will appear here"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final received = data['received'] ?? false;


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
                child: ListTile(
                  title: Text(
                    data['title'] ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Description: ${data['description'] ?? ''}"),
                      Text("Location of finding: ${data['location'] ?? ''}"),
                      Text("Found on: $formattedDate"),
                      Text("Report made by: ${data['userName'] ?? ''} (SAP Id: ${data['sapId'] ?? ''})"),

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
                        icon: const Icon(Icons.visibility),
                        label: const Text("View Image"),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: received
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.pink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          received
                              ? "✓ Item Received by the department"
                              : "✕ Item not yet received by the department",
                          style: TextStyle(
                            color: received ? Colors.green[700] : Colors.red[700],
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
  }
}
