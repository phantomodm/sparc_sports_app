// leaderboard_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart'; // Import your theme and models

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<UserRank> _userRanks = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRanks();
  }

  Future<void> _fetchUserRanks() async {
    final userRanks = await RankingService().getTopUsers(20); // Fetch top 20 users
    setState(() {
      _userRanks = userRanks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: _userRanks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _userRanks.length,
        itemBuilder: (context, index) {
          final userRank = _userRanks[index];
          return _buildUserRankTile(userRank, index + 1); // Pass rank to the tile
        },
      ),
    );
  }

  Widget _buildUserRankTile(UserRank userRank, int rank) {
    return ListTile(
      leading: CircleAvatar(
        // TODO: Display user avatar
      ),
      title: Text(
        // TODO: Display user name
      ),
      trailing: Text(
        '$rank. ${userRank.points} points',
      ),
    );
  }
}