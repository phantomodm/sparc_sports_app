import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

// In your PromotionalBanner widget
class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({super.key});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  String? imageUrl;
  String? title;
  String? description;

  @override
  void initState() {
    super.initState();
    _fetchBannerData();
  }

  Future<void> _fetchBannerData() async {
    // 1. Fetch banner data from Firebase Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    imageUrl = remoteConfig.getString('banner_image_url');
    title = remoteConfig.getString('banner_title');
    description = remoteConfig.getString('banner_description');

    // 2. Update the state to rebuild the widget
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && title != null && description != null) {
      return Container(
        // Display the banner using fetched data
      );
    } else {
      return Container(
        // Display a placeholder or loading indicator
      );
    }
  }
}
