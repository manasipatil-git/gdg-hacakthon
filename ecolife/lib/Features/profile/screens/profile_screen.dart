import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/avatar_library_screen.dart';
import '../widgets/achievement_card.dart';
import '../widgets/profile_stats_row.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String currentUid =
      FirebaseAuth.instance.currentUser!.uid;

  late final bool isMe;

  final Map<String, Color> avatarColors = {
    'avatar_1': Colors.green,
    'avatar_2': Colors.purple,
    'avatar_3': Colors.orange,
    'avatar_4': Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    isMe = widget.userId == currentUid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          final String userName = data['name'] ?? 'User';
          final String avatar = data['avatar'] ?? 'avatar_1';

          final List followers =
              List.from(data['followers'] ?? []);
          final List following =
              List.from(data['following'] ?? []);

          final Color bgColor =
              avatarColors[avatar] ?? Colors.green;

          return SingleChildScrollView(
            child: Column(
              children: [
                /// TOP SECTION
                Container(
                  height: 280,
                  width: double.infinity,
                  color: bgColor.withOpacity(0.15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// AVATAR
                      GestureDetector(
                        onTap: isMe
                            ? () async {
                                final selectedAvatar =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AvatarLibraryScreen(),
                                  ),
                                );

                                if (selectedAvatar != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.userId)
                                      .update({
                                    'avatar': selectedAvatar,
                                  });
                                }
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bgColor,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Text(
                              avatar.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// NAME + EDIT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  _editName(userName),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// REAL-TIME STATS
                ProfileStatsRow(
                  followers: followers.length,
                  following: following.length,
                  ecoCircle: 0,
                ),

                const SizedBox(height: 24),

                const AchievementCard(),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editName(String currentName) {
    final controller =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(hintText: 'Enter name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .update({
                'name': controller.text.trim(),
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}