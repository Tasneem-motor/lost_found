import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostReportsScreen extends StatelessWidget {
  LostReportsScreen({super.key});

  final CollectionReference lostReports =
      FirebaseFirestore.instance.collection('lost_reports');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost Reports"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: lostReports.snapshots(),
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

          final docs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final aResolved = (a.data() as Map)['resolved'] ?? false;
              final bResolved = (b.data() as Map)['resolved'] ?? false;
              return aResolved == bResolved
                  ? 0
                  : aResolved
                      ? 1   // true goes last
                      : -1;
            });

          if (docs.isEmpty) {
            return const Center(child: Text("Lost reports will appear here"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final resolved = data['resolved'] ?? false;


              final timestamp = data['lost on'] as Timestamp?;
              final date = timestamp?.toDate();

              final formattedDate = date != null
                  ? "${date.day}-${date.month}-${date.year}"
                  : "No Date";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    data['itemName'] ?? 'No Title',
                    style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Description: ${data['description'] ?? ''}",
                      style: TextStyle(
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),),
                      Text("Location: ${data['location'] ?? ''}",
                      style: TextStyle(
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),),
                      Text("Lost on: $formattedDate",
                          style: TextStyle(
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),),
                      Text("Report made by: ${data['userName'] ?? ''} (SAP Id: ${data['sapId'] ?? ''} ),",
                      style: TextStyle(
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Report"),
                          content: const Text(
                            "Are you sure you want to delete this report?\n\nThis action cannot be undone.\n\nReport once deleted cannot be restored by any means"
                          ),
                          actions: [

                            // Cancel button
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),

                            // Confirm delete button
                            TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('lost_reports')
                                    .doc(doc.id)
                                    .delete();

                                Navigator.pop(context); // close dialog

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Report deleted successfully"),
                                  ),
                                );
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
              );
            },
          );
        },
      ),
    );
  }
}
