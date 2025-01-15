import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatelessWidget {
  final dynamic entity;
  final VoidCallback onShare;

  const ShareWidget({Key? key, required this.entity, required this.onShare}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_outlined),
      onPressed: () {
        // TODO: Prepare share content based on the entity
        Share.share('Check out this ${entity.runtimeType}: ${entity.title}'); // Customize share content
        onShare();
      },
    );
  }
}