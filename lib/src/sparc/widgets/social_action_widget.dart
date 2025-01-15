import 'package:flutter/material.dart';

class SocialActionsWidget extends StatelessWidget {
  final dynamic entity;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const SocialActionsWidget({
    Key? key,
    required this.entity,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute icons evenly
      children: [
        IconButton(
          icon: const Icon(Icons.favorite_border), // Or Icons.favorite if liked
          onPressed: onLike,
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: onComment,
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: onShare,
        ),
      ],
    );
  }
}