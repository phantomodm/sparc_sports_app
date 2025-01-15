// group_thread_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/sparc_sports_app.dart';

class GroupThreadScreen extends StatefulWidget {
  final GroupPost post;

  const GroupThreadScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<GroupThreadScreen> createState() => _GroupThreadScreenState();
}

class _GroupThreadScreenState extends State<GroupThreadScreen> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildPostWidget(widget.post),
                ...widget.post.replies.map((reply) => _buildReplyWidget(reply)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(hintText: 'Add a reply...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // TODO: Add reply to the post
                    try {
                      final reply = GroupPostReply(
                      id: '', // Generate a unique ID
                      content: _replyController.text,
                      author: _authService.getCurrentUser()!,
                      timestamp: DateTime.now(),
                      );

                      await GroupPostService().addReplyToGroupPost(widget.post.id, reply);

                      // Clear the reply text field
                      _replyController.clear();

                      // TODO: Update the UI to show the new reply
                    } catch (e) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding reply: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostWidget(GroupPost post) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: AppThemes.textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              'By ${post.author.userName}',
              style: AppThemes.textTheme.caption,
            ),
            const SizedBox(height: 16),
            Text(post.content),
            const SizedBox(height: 16),
            SocialActionsWidget(
              entity: post,
              onLike: () {
                // TODO: Implement like functionality
              },
              onComment: () {
                // TODO: Implement comment functionality
              },
              onShare: () {
                // TODO: Implement share functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyWidget(GroupPostReply reply) {
    return ListTile(
      title: Text(reply.content),
      subtitle: Text('By ${reply.author.userName}'),
    );
  }
}