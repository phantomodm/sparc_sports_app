import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/sparc/feed/bloc/post_bloc.dart';

import '../../core/themes/themes.dart';

// ... (Your AppFonts class and theme definitions)

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more posts when reaching the end of the list
      context.read<PostBloc>().add(LoadMorePosts());
    }
  }

  void _showCommentModal(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentModal(post: post); // Your comment modal widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppFonts.appBarGradient),
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  // Render a loading indicator at the end of the list
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final post = state.posts[index];
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(post.user.profileImageUrl),
                          ),
                          title: Text(post.user.name),
                          subtitle: Text(post.timestamp),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(post.content),
                        ),
                        if (post.imageUrl != null)
                          Image.network(post.imageUrl!),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                onPressed: () {
                                  // TODO: Implement like functionality
                                },
                              ),
                              InkWell(
                                onTap: () => _showCommentModal(context, post),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(Icons.comment),
                                    if (post.commentCount > 0)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Text(
                                            '${post.commentCount}',
                                            style: const TextStyle(fontSize: 10, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {
                                  // TODO: Implement share functionality
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create new post functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}