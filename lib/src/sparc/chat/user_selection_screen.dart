import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';
import 'package:sparc_sports_app/src/core/services/user_service.dart';
import 'package:sparc_sports_app/src/sparc/chat/chat_screen.dart';
import 'package:sparc_sports_app/src/sparc/chat/models/chat_message_models.dart';
import 'package:sparc_sports_app/src/sparc/chat/services/chat_service.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({Key? key}) : super(key: key);

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<AuthUser> _users = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await UserService().getUsers(); // Fetch all users
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          // Apply search filter
          if (_searchText.isNotEmpty &&
              !user.displayName!.toLowerCase().contains(_searchText.toLowerCase())) {
            return const SizedBox.shrink();
          }
          return _buildUserTile(user);
        },
      ),
    );
  }

  Widget _buildUserTile(AuthUser user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.photoURL ?? ''),
      ),
      title: Text(user.displayName ?? 'Unknown User'),
      onTap: () {
        _showConfirmationDialog(context, user);
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, AuthUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: Text('Start a chat with ${user.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _startChat(context, user);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _startChat(BuildContext context, AuthUser user) async {
    try {
      final chat = ChatMessage(
        id: const Uuid().v4(),
        type: 'direct',
        members: [_authService.getCurrentUser()!.uid, user.userId!],
      );

      await ChatService().createChat(chat);

      // Navigate to ChatScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chat: chat),
        ),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating chat: $e')),
      );
    }
  }
}