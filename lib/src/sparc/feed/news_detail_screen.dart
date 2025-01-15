
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_item_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Import your theme and models

class NewsDetailsScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailsScreen({Key? key, required this.newsItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the news image
            Image.network(newsItem.imageUrl),
            const SizedBox(height: 16),

            // Display the title
            Text(
              newsItem.title,
              style: AppThemes.headline5,
            ),
            const SizedBox(height: 8),

            // Display the author and publication date (if available)
            if (newsItem.author != null && newsItem.publishedAt != null)
              Text(
                'By ${newsItem.author} - ${newsItem.publishedAt}',
                style: AppThemes.caption,
              ),
            const SizedBox(height: 16),

            // Display the full article text
            Text(
              newsItem.content, // Assuming NewsItem has a content property
              style: AppThemes.bodyText1,
            ),
            ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse(newsItem.articleUrl);
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: const Text('View Original Article'),
            ),
          ],
        ),
      ),
    );
  }
}