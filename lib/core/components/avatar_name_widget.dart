import 'package:flutter/material.dart';

class AvatarName extends StatelessWidget {
  final String name;
  late final String avatarUrl;

  AvatarName({
    super.key,
    required this.name,
  }) {
    avatarUrl =
        'https://ui-avatars.com/api/?name=$name&size=128&background=415f91&color=fff';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.0,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
