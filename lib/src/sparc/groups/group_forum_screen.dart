// group_forum_screen.dart

import 'package:flutter/material.dart';

class GroupForumScreen extends StatefulWidget {
  final String groupId;

  const GroupForumScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupForumScreen> createState() => _GroupForumScreenState();
}

class _GroupForumScreenState extends State<GroupForumScreen> {
  List<GroupPost> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchGroupPosts();
  }

  Future<void> _fetchGroupPosts() async {
    final posts = await GroupPostService().getGroupPosts(widget.groupId);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Forum'),
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _buildGroupPostCard(post);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGroupPostScreen(groupId: widget.groupId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupPostCard(GroupPost post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(post.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By ${post.author.userName}',
              style: AppThemes.textTheme.caption,
            ),
            Text(
              post.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupThreadScreen(post: post),
            ),
          );
        },
      ),
    );
  }
}