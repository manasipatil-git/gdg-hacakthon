import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/firestore_service.dart';
import '../widgets/user_list_tile.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final FirestoreService _firestore = FirestoreService();
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuggestedUsers();
  }

  /// Load top leaderboard users (default view)
  Future<void> _loadSuggestedUsers() async {
    final suggested =
        await _firestore.getSuggestedUsers(currentUid: currentUid);
    setState(() {
      users = suggested;
      isLoading = false;
    });
  }

  /// Search users by name
  Future<void> _onSearchChanged(String query) async {
    if (query.isEmpty) {
      _loadSuggestedUsers();
      return;
    }

    final results = await _firestore.searchUsersByName(
      query: query,
      currentUid: currentUid,
    );

    setState(() {
      users = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    final user = users[index];

                    return UserListTile(
                      name: user['name'] ?? 'User',
                      ecoScore: user['ecoScore'] ?? 0,
                      trailing: ElevatedButton(
                        child: const Text('Follow'),
                        onPressed: () async {
                          await _firestore.followUser(
                            currentUid: currentUid,
                            targetUid: user['uid'],
                          );

                          // Refresh list after follow
                          _controller.text.isEmpty
                              ? _loadSuggestedUsers()
                              : _onSearchChanged(_controller.text);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}