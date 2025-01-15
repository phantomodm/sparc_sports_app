// favorite_news_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/favorite_service.dart';
import 'package:sparc_sports_app/src/sparc/feed/services/news_item_model.dart';

class FavoriteNewsScreen extends StatefulWidget {
  const FavoriteNewsScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteNewsScreen> createState() => _FavoriteNewsScreenState();
}

class _FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  List<NewsItem> _favoriteNewsItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteNewsItems();
  }

  Future<void> _fetchFavoriteNewsItems() async {
    final newsItems = await FavoriteService().getFavoriteNewsItems(); // Fetch favorite news items from your FavoriteService
    setState(() {
      _favoriteNewsItems = newsItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite News'),
      ),
      drawer: Drawer( // Add the Drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Sparc Sports App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // TODO: Navigate to HomeScreen
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorite News'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer (already on this screen)
                },
              ),
              // ... add more drawer items
            ],
          ),
      ),
      body: _favoriteNewsItems.isEmpty
          ? const Center(child: Text('No favorite news items yet.'))
          : ListView.builder(
        itemCount: _favoriteNewsItems.length,
        itemBuilder: (context, index) {
          final newsItem = _favoriteNewsItems[index];
          return _buildNewsItemCard(newsItem);
        },
      ),
    );
  }

  Widget _buildNewsItemCard(NewsItem newsItem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.network(newsItem.imageUrl),
        title: Text(newsItem.title),
        subtitle: Text(newsItem.description),
        onTap: () {
          // TODO: Navigate to NewsDetailsScreen
        },
      ),
    );
  }
}