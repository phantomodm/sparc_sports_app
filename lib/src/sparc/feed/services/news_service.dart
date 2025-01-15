// news_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String _apiKey = 'YOUR_ESPN_API_KEY'; // Replace with your actual API key

  Future<List<NewsItem>> getNewsItems() async {
    final response = await http.get(
      Uri.parse('https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/news'),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> articles = jsonData['articles'];
      return articles.map((article) => NewsItem.fromJson(article)).toList(); // Assuming you have a fromJson factory constructor in NewsItem
    } else {
      throw Exception('Failed to fetch news items');
    }
  }
}