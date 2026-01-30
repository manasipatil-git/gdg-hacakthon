import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/firestore_service.dart';

class CreateEcoCircleScreen extends StatelessWidget {
  final List<String> members;
  CreateEcoCircleScreen({super.key, required this.members});

  final TextEditingController _nameController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create EcoCircle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Circle Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Create'),
              onPressed: () async {
                await _firestore.createEcoCircle(
                  name: _nameController.text,
                  memberUids: [uid, ...members],
                  createdBy: uid,
                );
                Navigator.popUntil(context, (r) => r.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}