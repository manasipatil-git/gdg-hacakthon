import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final String name;
  final int ecoScore;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UserListTile({
    super.key,
    required this.name,
    required this.ecoScore,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(name),
      subtitle: Text('EcoScore: $ecoScore'),
      trailing: trailing,
      onTap: onTap,
    );
  }
}