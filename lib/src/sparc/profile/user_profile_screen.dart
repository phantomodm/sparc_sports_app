// user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';
import 'package:sparc_sports_app/src/core/services/events_service.dart';
import 'package:sparc_sports_app/src/core/services/ranking_service.dart';
import 'package:sparc_sports_app/src/core/themes/app_themes.dart';
import 'package:sparc_sports_app/src/sparc/groups/services/groups_service.dart'; // Import your theme and models

class UserProfileScreen extends StatelessWidget {
  final AuthUser authUser; // Use AuthUser instead of User

  const UserProfileScreen({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(authUser.displayName ?? 'User Profile'), // Use displayName if available
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(authUser.photoURL ?? ''), // Use photoURL if available
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authUser.displayName ?? 'Unknown User', // Use displayName or "Unknown User"
                      style: AppThemes.headline5,
                    ),
                    FutureBuilder<UserRank>( // Fetch user rank
                      future: RankingService().getUserRank(authUser.userId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink(); // Or a loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final userRank = snapshot.data!;
                          return Text(
                            'Rank: ${userRank.rank} - Points: ${userRank.points}',
                            style: AppThemes.caption,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reputation: ${authUser.reputation ?? 0}', // Use reputation or 0
                      style: AppThemes.caption,
                    ),
                    ListView.builder(
                      itemCount: recentActivities.length, // Assuming you have a list of recentActivities
                      itemBuilder: (context, index) {
                        final activity = recentActivities[index];
                        return ListTile(
                          leading: _buildActivityIcon(activity.type), // Display an icon based on activity type
                          title: Text(_buildActivityText(activity)), // Display activity text
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Groups',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // TODO: Add ListView.builder to display user's groups

                    const SizedBox(height: 8),
                    FutureBuilder<List<Group>>( // Use FutureBuilder to fetch groups
                      future: GroupService().getGroupsForUser(authUser.userId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No groups joined.'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final group = snapshot.data![index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(group.groupPhoto ?? ''),
                                ),
                                title: Text(group.name),
                                onTap: () {
                                  // TODO: Navigate to GroupDetailsScreen
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Events',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // TODO: Add ListView.builder to display user's events
                    FutureBuilder<List<Event>>( // Use FutureBuilder to fetch events
                      future: EventService().getEventsForUser(authUser.userId!), // Assuming you have a getEventsForUser method in EventService
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No events attended.'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final event = snapshot.data![index];
                              return ListTile(
                                title: Text(event.title),
                                subtitle: Text(event.description),
                                onTap: () {
                                  // TODO: Navigate to EventDetailsScreen
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                    // ... (other sections like followers, following, etc.)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Followers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<User>>( // Use FutureBuilder to fetch followers
              future: UserService().getFollowers(authUser.userId!), // Assuming you have a getFollowers method in UserService
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No followers yet.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final follower = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(follower.profileImageUrl),
                        ),
                        title: Text(follower.userName),
                        onTap: () {
                          // TODO: Navigate to follower's profile
                        },
                      );
                    },
                  );
                }
              },
            ),

            const SizedBox(height: 16),
            const Text(
              'Following',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<User>>( // Use FutureBuilder to fetch following
              future: UserService().getFollowing(authUser.userId!), // Assuming you have a getFollowing method in UserService
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Not following anyone yet.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final following = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(following.profileImageUrl),
                        ),
                        title: Text(following.userName),
                        onTap: () {
                          // TODO: Navigate to following user's profile
                        },
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            Center( // Center the button
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to UserSettingsScreen
                },
                child: const Text('Settings'),
              ),
            ),
            // ... (rest of the UI, similar to before)
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(String activityType) {
    switch (activityType) {
      case 'post':
        return const Icon(Icons.article);
      case 'comment':
        return const Icon(Icons.comment);
      case 'joined_group':
        return const Icon(Icons.group_add);
      default:
        return const Icon(Icons.info);
    }
  }

  String _buildActivityText(dynamic activity) {
    switch (activity.type) {
      case 'post':
        return 'Created a new post: ${activity.data['content']}'; // Assuming data contains 'content'
      case 'comment':
        return 'Commented on a post: ${activity.data['content']}'; // Assuming data contains 'content'
      case 'joined_group':
        return 'Joined the group: ${activity.data['groupName']}'; // Assuming data contains 'groupName'
      default:
        return 'Performed an activity.';
    }
  }
}