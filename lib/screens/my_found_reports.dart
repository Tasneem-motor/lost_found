import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFoundReportsScreen extends StatelessWidget {
  MyFoundReportsScreen({super.key});

  final CollectionReference foundReports =
      FirebaseFirestore.instance.collection('found_reports');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: foundReports
        .where(
          'uid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
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
            return const Center(child: Text("Found item's reports made by you will appear here"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;


              final timestamp = data['timestamp'] as Timestamp?;
              final date = timestamp?.toDate();

              final formattedDate = date != null
                  ? "${date.day}-${date.month}-${date.year}"
                  : "No Date";

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
                      Text("Location: ${data['location'] ?? ''}"),
                      Text("Reported on: $formattedDate"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                       // 🗑 Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('found_reports')
                              .doc(doc.id)
                              .delete();
                        },
                      ),
                    ],
                ),
              )
              );
            },
          );
        },
      );
  }
}
