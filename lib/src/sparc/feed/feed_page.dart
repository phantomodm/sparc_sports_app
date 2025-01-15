import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/sparc/feed/bloc/home_feed_bloc.dart';
import 'package:sparc_sports_app/src/sparc/feed/bloc/post_bloc.dart';
import 'package:sparc_sports_app/src/sparc/models/post_model.dart';
import 'package:sparc_sports_app/src/sparc/widgets/post_card_widget.dart';

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
    if (_isBottom) context.read<HomeFeedBloc>().add(LoadHomeFeed());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _showCommentModal(BuildContext context, SparcPost post) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CommentModal(post: post); // Your comment modal widget
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeFeedBloc, HomeFeedState>(
      builder: (context, state) {
        print(state);
        return switch (state) {
          HomeFeedLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          HomeFeedError() => const Center(
            child: Text('Something went wrong!'),
          ),
          HomeFeedLoaded() => _buildPostList(state.posts),
          _ => throw UnimplementedError(),
        };
      },
    );
  }

  Widget _buildPostList(List<dynamic> posts) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCardWidget(post: post);
      },
    );
  }
}