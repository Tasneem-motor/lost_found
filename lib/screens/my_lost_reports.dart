import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLostReportsScreen extends StatefulWidget {
  const MyLostReportsScreen({super.key});

  @override
  State<MyLostReportsScreen> createState() =>
      _MyLostReportsScreenState();
}

class _MyLostReportsScreenState extends State<MyLostReportsScreen> {

  final CollectionReference lostReports =
      FirebaseFirestore.instance.collection('lost_reports');

  Future<void> markAsResolved(DocumentSnapshot doc) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirm Resolution"),
        content: const Text(
          "Once marked as resolved, this cannot be changed. Continue?",
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      )]);
    },
  );

  if (confirm == true) {
    await doc.reference.update({"resolved": true});
  }
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: lostReports
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
            return const Center(child: Text("Lost item's reports made by you will appear here"));
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //if (resolved)
                      Text(
                        data['itemName'] ?? 'No Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const SizedBox(height: 6),
                      Text(
                        "Description: ${data['description'] ?? ''}",
                        style: TextStyle(
                          fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                          color: resolved ? Colors.grey : Colors.black,
                        ),
                      ),
                      Text("Location: ${data['location'] ?? ''}",
                        style: TextStyle(
                            fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                            color: resolved ? Colors.grey : Colors.black,
                          ),
                          ),
                      Text("Lost on: $formattedDate",
                        style: TextStyle(
                            fontStyle: resolved ? FontStyle.italic : FontStyle.normal,
                            color: resolved ? Colors.grey : Colors.black,
                          ),
                          ),
                    ],
                  ),

                  
                  trailing: 
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      resolved
                        ? const Text(
                            "Resolved",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Switch(
                            value: resolved,
                            onChanged: (value) {
                              markAsResolved(doc);
                            },
                          ),

                       // Delete Button
                      if (!resolved)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('lost_reports')
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
