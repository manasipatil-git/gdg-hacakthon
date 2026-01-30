import 'package:flutter/material.dart';

import '../screens/avatar_library_screen.dart';
import '../widgets/achievement_card.dart';
import '../widgets/profile_stats_row.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Sanidhya';
  String avatar = 'avatar_1';

  // avatar → background color mapping
  final Map<String, Color> avatarColors = {
    'avatar_1': Colors.green,
    'avatar_2': Colors.purple,
    'avatar_3': Colors.orange,
    'avatar_4': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        avatarColors[avatar] ?? Colors.green;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TOP SECTION (avatar + background)
            Container(
              height: 280,
              width: double.infinity,
              color: bgColor.withOpacity(0.15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// AVATAR
                  GestureDetector(
                    onTap: () async {
                      final selectedAvatar =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AvatarLibraryScreen(),
                        ),
                      );

                      if (selectedAvatar != null) {
                        setState(() {
                          avatar = selectedAvatar;
                        });
                      }
                    },
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
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _editName,
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// FOLLOWERS / FOLLOWING / ECO CIRCLE
            const ProfileStatsRow(
              followers: 120,
              following: 80,
              ecoCircle: 12,
            ),

            const SizedBox(height: 24),

            /// ACHIEVEMENTS (STATIC)
            const AchievementCard(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _editName() {
    final controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = controller.text.trim();
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
