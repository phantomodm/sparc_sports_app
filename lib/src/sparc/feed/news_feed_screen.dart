// news_feed_screen.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/sparc/feed/news_detail_screen.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/favorite_service.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_cache_service.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_item_model.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_service.dart'; // Import your theme and models

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<NewsItem> _newsItems = [];
  String _selectedCategory = 'all';
  final List<String> _categories = [
    'all',
    'MLB',
    'NBA',
    'NFL'
  ]; // Example categories
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNewsItems();
  }

  Future<void> _fetchNewsItems(
      {String category = 'all', String? searchQuery}) async {
    try {
      final newsItems = await NewsService()
          .getNewsItems(category: category, searchQuery: searchQuery);
      setState(() {
        _newsItems = newsItems;
      });
      await NewsCacheService()
          .cacheNewsItems(newsItems); // Cache the fetched news items
    } catch (e) {
      // If there's an error fetching news items, try to load from cache
      final cachedNewsItems = await NewsCacheService().getCachedNewsItems();
      if (cachedNewsItems.isNotEmpty) {
        setState(() {
          _newsItems = cachedNewsItems;
        });
        // Show a message to the user indicating that offline data is being displayed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Showing cached news items.')),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching news items: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News Feed'),
          actions: [
            DropdownButton<String>(
              value: _selectedCategory,
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _fetchNewsItems(category: _selectedCategory);
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search news...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (text) {
                    _fetchNewsItems(
                        category: _selectedCategory, searchQuery: text);
                  },
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _fetchNewsItems(
              category: _selectedCategory, searchQuery: _searchController.text),
          child: _newsItems.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _newsItems.length,
                  itemBuilder: (context, index) {
                    final newsItem = _newsItems[index];
                    return _buildNewsItemCard(newsItem);
                  },
                ),
        ));
  }

  Widget _buildNewsItemCard(NewsItem newsItem) {
    return StatefulBuilder(// Use StatefulBuilder to manage favorite state
        builder: (context, setState) {
      return FutureBuilder<bool>(
          // Use FutureBuilder to check if the item is a favorite
          future: FavoriteService().isNewsItemFavorite(newsItem),
          builder: (context, snapshot) {
            bool isFavorite = snapshot.data ?? false;
            return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(children: [
                  ListTile(
                    leading: Image.network(newsItem.imageUrl),
                    title: Text(
                      newsItem.title,
                      style: AppThemes.headline6, // Use headline6 for title
                    ),
                    subtitle: Text(
                      newsItem.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppThemes.bodyText2, // Use bodyText2 for description
                    ),
                    trailing: IconButton(
                      // Add share button
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share(
                            'Check out this news article: ${newsItem.articleUrl}');
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailsScreen(newsItem: newsItem),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ]));
          });
    });
  }
}
