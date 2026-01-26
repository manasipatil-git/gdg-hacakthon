import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';

class StreakCalendarCard extends StatelessWidget {
  const StreakCalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('daily_logs')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final loggedDates = snapshot.data!.docs
            .map((d) => d.id)
            .toSet(); // yyyy-MM-dd

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Days Streak 🔥',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.local_fire_department,
                      color: Colors.orange),
                ],
              ),

              const SizedBox(height: 12),

              // 📅 Week Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final date = today.subtract(Duration(days: 6 - index));
                  final key = DateFormat('yyyy-MM-dd').format(date);
                  final isDone = loggedDates.contains(key);
                  final isToday = DateFormat('yyyy-MM-dd')
                          .format(today) ==
                      key;

                  return Column(
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isToday
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isDone
                            ? const Icon(
                                Icons.local_fire_department,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 12),

              const Text(
                'Every day counts. Keep the momentum going 🌱',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
