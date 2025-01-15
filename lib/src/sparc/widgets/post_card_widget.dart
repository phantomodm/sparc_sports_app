import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/themes/app_themes.dart';
import 'package:sparc_sports_app/src/sparc/widgets/comment_modal_widget.dart';

class PostCardWidget extends StatelessWidget {
  final dynamic post;

  const PostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.author.profileImageUrl),
              radius: 20,
            ),
            title: Text(
              post.author.userName,
              style: AppThemes.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.timestamp.toString(),
              style: AppThemes.subtitle2,
            ),
             trailing: _buildPostOptions(context, post)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              post.content,
              style: AppThemes.bodyText1,
            ),
          ),
          // ... (Image.network)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ... (Like button)
                _buildLikeButton(context, post),
                _buildCommentButton(context, post),
                _buildShareButton(context, post),
                IconButton(
                  icon: Icon(Icons.comment_outlined,
                      color: AppThemes.primaryColor),
                  onPressed: () {
                    // TODO: Handle comment action
                    _handleCommentAction(context, post);
                  },
                ),
                IconButton(
                  icon:
                      Icon(Icons.share_outlined, color: AppThemes.primaryColor),
                  onPressed: () {
                    // TODO: Handle share action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context, dynamic post) {
    bool showBadgeAnimation = false;
    return StatefulBuilder(builder: (context, setState) {
      Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.comment_outlined, color: AppThemes.primaryColor),
            onPressed: () {
              _handleCommentAction(context, post);
              setState(() {
                showBadgeAnimation = true; // Trigger the animation
                post.commentCount++; // Increment the comment count (assuming you have this logic)
              });
            },
          ),
          if (post.commentCount > 0)
            AnimatedContainer(
                // Use AnimatedContainer for the animation
                duration: const Duration(milliseconds: 300),
                curve: Curves.bounceOut,
                transform: Matrix4.identity()
                  ..scale(showBadgeAnimation ? 1.1 : 1.0),
                onEnd: () {
                  // Reset the animation after it completes
                  setState(() {
                    showBadgeAnimation = false;
                  });
                },
                child: Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                )),
        ],
      );
    });
  }

  Widget _buildShareButton(BuildContext context, dynamic post) {
    bool showBadgeAnimation = false;
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.share_outlined, color: AppThemes.primaryColor),
          onPressed: () {
            // TODO: Handle share action (e.g., using share_plus package)
            setState(){
              showBadgeAnimation = true; // Trigger the animation
              post.shareCount++;
            }
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

  // Method to handle comment action
  void _handleCommentAction(BuildContext context, dynamic post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CommentModalWidget(
        postId: post.id,
        authorUsername: post.author.userName,
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, dynamic post) {
    bool isLiked = false; // Add a state variable to track the like status
    return StatefulBuilder(
      // Use StatefulBuilder to manage the like state
      builder: (context, setState) {
        return IconButton(
          icon: AnimatedContainer(
            // Use AnimatedContainer for the animation
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(isLiked ? 1.2 : 1.0),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : AppThemes.primaryColor,
            ),
          ),
          onPressed: () {
            setState(() {
              isLiked = !isLiked; // Toggle the like status
            });
            // TODO: Handle like action in your database
          },
        );
      },
    );
  }

  Widget _buildPostOptions(BuildContext context, dynamic post) {
    // Check if the current user is the author of the post
    if (post.author.userId == _authService.getCurrentUser()?.uid) {
      return PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            // TODO: Handle edit action (e.g., navigate to an edit screen)
          } else if (value == 'delete') {
            // TODO: Handle delete action (e.g., show a confirmation dialog)
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink(); // Don't show options if not the author
    }
  }
}
