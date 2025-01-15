// news_cache_service.dart

import 'package:hive/hive.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_item_model.dart';

class NewsCacheService {
  final String _boxName = 'newsCache';

  Future<void> cacheNewsItems(List<NewsItem> newsItems) async {
    final box = await Hive.openBox<NewsItem>(_boxName);
    for (var newsItem in newsItems) {
      await box.put(newsItem.id, newsItem); // Assuming NewsItem has an id property
    }
  }

  Future<List<NewsItem>> getCachedNewsItems() async {
    final box = await Hive.openBox<NewsItem>(_boxName);
    return box.values.toList();
  }

// ... (optional) add methods to clear cache or remove individual items
}