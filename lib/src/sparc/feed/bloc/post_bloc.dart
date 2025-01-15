// Post events
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';

import 'package:sparc_sports_app/src/sparc/models/post_model.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {}

class LoadMorePosts extends PostEvent {}

// Post states
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<SparcPost> posts;
  final bool hasReachedMax;

  const PostLoaded({this.posts = const [], this.hasReachedMax = false});

  @override
  List<Object> get props => [posts, hasReachedMax];

  PostLoaded copyWith({
    List<SparcPost>? posts,
    bool? hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PostError extends PostState {
  final String error;

  const PostError({required this.error});

  @override
  List<Object> get props => [error];
}

// Post Bloc
class PostBloc extends Bloc<PostEvent, PostState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<SparcPost> _posts = [];
  bool _hasReachedMax = false;
  final int _limit = 10; // Number of posts to load per batch
  DocumentSnapshot? _lastDocument;

  PostBloc() : super(PostLoading()) {
    on<LoadPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await _fetchPosts();
        _posts = posts;
        _hasReachedMax = posts.length < _limit;
        emit(PostLoaded(posts: _posts, hasReachedMax: _hasReachedMax));
      } catch (e) {
        emit(PostError(error: e.toString()));
      }
    });

    on<LoadMorePosts>((event, emit) async {
      if (!_hasReachedMax) {
        try {
          final newPosts = await _fetchPosts();
          if (newPosts.isNotEmpty) {
            _posts.addAll(newPosts);
            _hasReachedMax = newPosts.length < _limit;
            emit(PostLoaded(posts: _posts, hasReachedMax: _hasReachedMax));
          }
        } catch (e) {
          emit(PostError(error: e.toString()));
        }
      }
    });
  }

  Future<List<SparcPost>> _fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .limit(_limit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(_limit)
          .get();
    }

    _lastDocument = querySnapshot.docs.last;

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return SparcPost(
        id: doc.id,
        user: AuthUser(
          id: data['userId'],
          name: data['userName'],
          profileImageUrl: data['userProfileImageUrl'],
        ),
        content: data['content'],
        imageUrl: data['imageUrl'],
        timestamp: data['timestamp'],
        commentCount: data['commentCount'] ?? 0,
      );
    }).toList();
  }
}

/*
Future<List<SparkPost>> _fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://xxx/getposts?page=$_page&limit=$_limit'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Assuming your API response is a list of posts
      return (jsonData as List).map((postJson) => SparkPost.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}*/
