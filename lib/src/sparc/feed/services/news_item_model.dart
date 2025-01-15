// news_item_model.dart

class NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final String articleUrl;
  // ... other relevant fields (e.g., publishedAt, source, etc.)

  NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleUrl,
    // ... other fields
  });

// ... factory constructor to create NewsItem from JSON response
}