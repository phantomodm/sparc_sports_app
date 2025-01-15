// media_widget.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  final List<String> mediaUrls;

  const MediaWidget({Key? key, required this.mediaUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaUrls.isEmpty) {
      return const SizedBox.shrink();
    } else if (mediaUrls.length == 1) {
      return _buildSingleMedia(mediaUrls.first);
    } else {
      return _buildMediaSlider(mediaUrls);
    }
  }

  Widget _buildSingleMedia(String mediaUrl) {
    // Logic to determine if it's an image or video URL
    if (mediaUrl.endsWith('.jpg') || mediaUrl.endsWith('.png')) {
      return Image.network(
        mediaUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (mediaUrl.endsWith('.mp4') || mediaUrl.endsWith('.mov')) {
      // TODO: Implement video player
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Video Player Here')),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildMediaSlider(List<String> mediaUrls) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: false,
      ),
      items: mediaUrls.map((mediaUrl) {
        return Builder(
          builder: (BuildContext context) {
            return _buildSingleMedia(mediaUrl);
          },
        );
      }).toList(),
    );
  }
}