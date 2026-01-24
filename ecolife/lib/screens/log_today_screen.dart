import 'package:flutter/material.dart';

class LogTodayScreen extends StatelessWidget {
  const LogTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Today')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Transport used today (km)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Electricity usage (units)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
