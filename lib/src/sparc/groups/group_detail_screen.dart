// group_details_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/services/fcm_service.dart';
import 'package:sparc_sports_app/src/core/themes/app_themes.dart';
import 'package:sparc_sports_app/src/sparc/events/add_event_screen.dart';
import 'package:sparc_sports_app/src/sparc/groups/services/groups_service.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;
  bool isMember;

  const GroupDetailsScreen({Key? key, required this.group}) : super(key: key);

  Future<void> _createGroup(BuildContext context) async {
    try {
      final user = _authService.getCurrentUser()!;
      final newGroupName = _nameController.text;
      final newGroupDescription = _descriptionController.text;

      // Generate a unique ID for the group
      final groupId = const Uuid().v4();

      String? groupPhotoUrl;
      if (_selectedImage != null) {
        groupPhotoUrl = await ImageService().uploadImageToFirestore(
          _selectedImage,
          'group_$groupId',
        );
      }

      final newGroup = Group(
        id: groupId,
        name: newGroupName,
        description: newGroupDescription,
        createdBy: user,
        // Assuming you have an AuthService
        members: [user],
        // Initially, the creator is the only member
        groupPhoto: groupPhotoUrl,
        // ... other fields (createdDate, etc.)
      );

      await GroupService().createGroup(newGroup);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating group: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = group.createdBy.userId == _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Avatar and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(group.groupPhoto),
                ),
                const SizedBox(width: 16),
                Text(
                  group.name,
                  style: AppThemes.headline5,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Group Description
            Text(
              group.description,
              style: AppThemes.bodyText1,
            ),
            const SizedBox(height: 16),

            // Members List
            const Text(
              'Members',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              // Important for ListView inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(),
              // Disable scrolling for the inner ListView
              itemCount: group.members.length,
              itemBuilder: (context, index) {
                final member = group.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.profileImageUrl),
                  ),
                  title: Text(member.userName),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Upcoming Events',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // ... (ListView.builder for events)

            if (isAdmin)
              ElevatedButton( // "Create Event" button within the section
                onPressed: () {
                  // TODO: Navigate to AddEventScreen with groupId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEventScreen(groupId: group.id),
                    ),
                  );
                },
                child: const Text('Create Event'),
              ),
            const Text(
              'Recent Activity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<
                List<Activity>>( // Use FutureBuilder to fetch activity data
              future: GroupService().getRecentActivityForGroup(group.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No recent activity.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final activity = snapshot.data![index];
                      return ListTile(
                        leading: _buildActivityIcon(activity.type),
                        // Display icon based on activity type
                        title: Text(_buildActivityText(
                            activity)), // Display activity text
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 32),

            // "Join Group" or "Leave Group" Button
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    // TODO: Implement "Join Group" or "Leave Group" functionality
                    final isMember = group.members.any((member) =>
                    member.userId == _authService.getCurrentUser()!.uid);

                    if (isMember) {
                      // Leave the group
                      await GroupService().leaveGroup(
                          group.id, _authService.getCurrentUser()!.uid);
                      // TODO: Update UI to reflect leaving the group (e.g., change button text)
                    } else {
                      // Join the group
                      await GroupService().joinGroup(
                          group.id, _authService.getCurrentUser()!.uid);
                      // TODO: Update UI to reflect joining the group (e.g., change button text)
                    }
                  },
                  child: Text(isMember ? 'Leave Group' : 'Join Group'),
                  , // Or "async Leave Group" if already a member
              ),
            ),
            // "Invite User" Button
            ElevatedButton(
              onPressed: () async {
                // TODO: Implement logic to select a user and invite them
                final TextEditingController _userController = TextEditingController();
                final String? userId = await showDialog<String>(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: const Text('Invite User'),
                          content: TextField(
                            controller: _userController,
                            decoration: const InputDecoration(
                                hintText: 'Enter user ID or email'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, _userController.text),
                              child: const Text('Invite'),
                            ),
                          ],
                        )
                );
                if (userId != null) {
                  try {
                    await GroupService().inviteUserToGroup(group.id, userId);
                    // TODO: Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User invited successfully!')),
                    );
                    // Send invitation notification using FCM
                    // Send invitation notification
                    await FCMService().sendNotification(
                      userId, // Assuming you have the FCM token of the user
                      'Group Invitation',
                      'You have been invited to join ${group.name}',
                    );
                  } catch (e) {
                    // TODO: Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error inviting user: $e')),
                    );
                  }
                }
              },
              child: const Text('Invite User'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper functions to build activity icon and text
  Widget _buildActivityIcon(String activityType) {
    switch (activityType) {
      case 'post':
        return const Icon(Icons.article);
      case 'comment':
        return const Icon(Icons.comment);
      case 'member_joined':
        return const Icon(Icons.person_add);
      default:
        return const Icon(Icons.info);
    }
  }

  String _buildActivityText(Activity activity) {
    switch (activity.type) {
      case 'post':
        return '${activity.user.userName} created a new post: ${activity
            .content}';
      case 'comment':
        return '${activity.user.userName} commented: ${activity.content}';
      case 'member_joined':
        return '${activity.user.userName} joined the group.';
      default:
        return 'Something happened in the group.';
    }
  }
}

// activity_model.dart


class Activity {
  final String type;
  final DateTime timestamp;
  final User? user;
  final String content;

  Activity({
    required this.type,
    required this.timestamp,
    required this.user,
    required this.content,
  });

// ... factory constructors for fromMap and toMap (if using Firestore)
}