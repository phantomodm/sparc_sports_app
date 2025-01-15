import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart'; // Import your theme and models
import 'package:flutter_quill/flutter_quill.dart';

class CommentModalWidget extends StatefulWidget {
  final String postId;
  final String authorUsername;

  const CommentModalWidget(
      {Key? key, required this.postId, required this.authorUsername})
      : super(key: key);

  @override
  State<CommentModalWidget> createState() => _CommentModalWidgetState();
}

class _CommentModalWidgetState extends State<CommentModalWidget> {
  final TextEditingController _commentController = TextEditingController();
  late final QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    // Optional: Pre-fill the comment input field
    _commentController.text = '@${widget.authorUsername} ';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCommentList(), // Display the list of comments
          const SizedBox(height: 16),
          _buildCommentInput(),
          const SizedBox(height: 16),
          Row(
            children: [
              // Add the user's avatar here
              CircleAvatar(
                backgroundImage: NetworkImage(
                    _authService.getCurrentUser()?.photoURL ?? ''), // Assuming you have an AuthService
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                // TODO: Change type
                child: TypeAheadField<dynamic>(
                  builder: (context, TextEditingController controller, FocusNode focusNode) {
                      return TextField(
                        controller: controller, // Use the provided controller
                        focusNode: focusNode, // Use the provided focusNode
                        decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        ),
                      );
                  },
                  suggestionsCallback: (pattern) async {
                    final suggestions = <String>[];
                    if (pattern.startsWith('@') && pattern.length > 1) {
                      // Fetch user suggestions from the database
                      final searchTerm = pattern.substring(1); // Remove the "@"
                      return await _databaseService.searchUsers(searchTerm);
                    }

                    // Extract hashtags from the text
                    final hashtags = extractHashtags(pattern);
                    suggestions.addAll(hashtags);

                    return suggestions;
                    return []; // Return an empty list if no "@" or not enough characters
                  },
                  itemBuilder: (context, suggestion) {
                    if (suggestion.startsWith('@')) {
                      // Build UI for user suggestions
                      final user = suggestion.substring(1); // Extract username
                      return ListTile(
                        leading: const CircleAvatar(
                          // TODO: Display user avatar
                        ),
                        title: Text(user),
                      );
                    } else {
                      // Build UI for hashtag suggestions
                      return ListTile(
                        title: Text(suggestion),
                      );
                    }
                  },
                  onSelected: (suggestion) {
                    if (suggestion.startsWith('@')) {
                      // Insert the user's ID into the TextField
                      // ... (same logic as before)
                    } else {
                      // Insert the hashtag into the TextField
                      final currentText = _commentController.text;
                      final lastHashtagIndex = currentText.lastIndexOf('#');
                      final newText = currentText.substring(0, lastHashtagIndex + 1) +
                          suggestion +
                          ' '; // Add a space after the hashtag
                      _commentController.value = TextEditingValue(
                        text: newText,
                        selection: TextSelection.collapsed(offset: newText.length),
                      );
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // TODO: Handle comment submission
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to extract hashtags
  List<String> extractHashtags(String text) {
    final regex = RegExp(r"\B#\w\w+"); // Matches words starting with "#"
    final matches = regex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  Widget _buildCommentList(comments) {
    return Expanded( // Wrap the ListView in Expanded
      child: ListView.builder(
        itemCount: comments.length, // Assuming you have a list of comments
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _buildCommentItem(comment);
        },
      ),
    );
  }


  Widget _buildReplyItem(reply) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(reply.author.profileImageUrl),
        radius: 12,
      ),
      title: Text(
        reply.author.userName,
        style: AppThemes.subtitle2
            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      subtitle: Text(
        reply.text,
        style: AppThemes.bodyText1?.copyWith(fontSize: 14),
      ),
    );
  }

  Widget _buildCommentItem(comment) {
    bool showReplyInput = false;
    final TextEditingController _replyController = TextEditingController();
    final GlobalKey _replyInputKey = GlobalKey();

    return StatefulBuilder( // Use StatefulBuilder to manage the state within the list item
        builder: (context, setState)
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comment.author.profileImageUrl),
              radius: 16,
            ),
            title: Text(
              comment.author.userName,
              style: AppThemes.subtitle2?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              comment.text,
              style: AppThemes.bodyText1,
            ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.reply),
                    onPressed: () {
                      setState(() {
                        showReplyInput = !showReplyInput;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.flag_outlined),
                    onPressed: () {
                      // TODO: Handle report action (e.g., show a report dialog)
                    },
                  ),
                ],
              ),
          ),
          // Display replies (if any)
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 56), // Indent replies
              child: Column(
                children: comment.replies.map((reply) {
                  return _buildReplyItem(reply);
                }).toList(),
              ),
            ),
          if (showReplyInput)
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 8),
              child: Row(
                children: [
                  if (showReplyInput)
                    SlideTransition( // Add SlideTransition
                      position: Tween<Offset>(
                        begin: const Offset(1, 0), // Start off-screen to the right
                        end: Offset.zero, // Slide to the normal position
                      ).animate(
                        CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!, // Use the modal's animation
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Padding(
                        key: _replyInputKey, // Assign the GlobalKey
                        padding: const EdgeInsets.only(left: 56, top: 8),
                        child: Row(
                          children:[
                            Expanded(
                              child: TextField(
                                controller: _replyController,
                                decoration: InputDecoration(
                                  hintText: 'Reply to ${comment.author.userName}',
                                  suffixIcon: IconButton( // Add a cancel button
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        showReplyInput = false; // Hide the reply input
                                        _replyController.clear(); // Clear the input field
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // 1. Get the comment text from the _commentController
                      final commentText = _commentController.text;

                      // 2. Create a new Comment object
                      final newComment = Comment(
                        author: _authService.getCurrentUser()!, // Assuming you have an AuthService
                        text: commentText,
                        timestamp: Timestamp.now(), // Or your preferred timestamp format
                      );

                      // 3. Add the new comment to the database
                      _databaseService.addComment(widget.postId, newComment);

                      // 4. Clear the comment input field
                      _commentController.clear();
                      // TODO: Handle reply submission
                    },
                  ),
                ],
              ),
            ),
          const Divider(), // Add a divider between comments
        ],
      );
    });
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              _authService.getCurrentUser()?.photoURL ?? ''), // Assuming you have an AuthService
          radius: 16,
        ),
        const SizedBox(width: 8),
        QuillToolbar(
          configurations: QuillToolbarConfigurations(
            sharedConfigurations: QuillSharedConfigurations(
              locale: const Locale('en'),
            ),
            // ... other toolbar customizations
          ),
          child: null,
        ),
        Expanded(
          child: QuillEditor( // Replace TextField with QuillEditor
            controller: _quillController,
            scrollController: ScrollController(),
            focusNode: FocusNode(),
            configurations: const QuillEditorConfigurations(),

          ),
        ),
        /*const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Add a comment...',
            ),
          ),
        ),*/
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            // TODO: Handle comment submission
          },
        ),
      ],
    );
  }

  Widget _buildCommentButton(BuildContext context, dynamic post) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.comment_outlined, color: AppThemes.primaryColor),
          onPressed: () {
            _handleCommentAction(context, post);
          },
        ),
        if (post.commentCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${post.commentCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context, dynamic post) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.share_outlined, color: AppThemes.primaryColor),
          onPressed: () {
            // TODO: Handle share action (e.g., using share_plus package)
          },
        ),
        if (post.shareCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${post.shareCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleCommentAction(BuildContext context, dynamic post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CommentModalWidget(
        postId: post.id,
        authorUsername: post.author.userName,
      ),
    );
  }

}