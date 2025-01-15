// home_feed_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparc_sports_app/src/sparc/models/post_model.dart';
import 'package:sparc_sports_app/src/sparc/services/database_service.dart';
// ... other  for Post model, etc.

part 'home_feed_event.dart';
part 'home_feed_state.dart';

class HomeFeedBloc extends Bloc<HomeFeedEvent, HomeFeedState> {
  final DatabaseService _databaseService;

  HomeFeedBloc({required DatabaseService databaseService})
      : _databaseService = databaseService,
        super(HomeFeedInitial()) {
    on<LoadHomeFeed>(_onLoadHomeFeed);
    on<RefreshHomeFeed>(_onRefreshHomeFeed);
  }

  Future<void> _onLoadHomeFeed(
      LoadHomeFeed event, Emitter<HomeFeedState> emit) async {
    emit(HomeFeedLoading());
    try {
      // 1. Fetch local posts based on user's location
      List<SparcPost> localPosts =
      await _databaseService.getLocalPosts(event.userLocation);

      // 2. Fetch global posts
      List<SparcPost> globalPosts = await _databaseService.getGlobalPosts();

      // 3. Combine and sort posts (you might want to add sorting logic here)
      List<SparcPost> allPosts = [...localPosts, ...globalPosts];

      emit(HomeFeedLoaded(posts: allPosts));
    } catch (e) {
      emit(HomeFeedError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeFeed(
      RefreshHomeFeed event, Emitter<HomeFeedState> emit) async {
    if (state is HomeFeedLoaded) {
      try {
        // 1. Fetch updated local posts
        List<SparcPost> localPosts =
        await _databaseService.getLocalPosts(event.userLocation);

        // 2. Fetch updated global posts
        List<SparcPost> globalPosts = await _databaseService.getGlobalPosts();

        // 3. Combine and sort updated posts
        List<SparcPost> allPosts = [...localPosts, ...globalPosts];

        emit(HomeFeedLoaded(posts: allPosts));
      } catch (e) {
        emit(HomeFeedError(e.toString()));
      }
    }
  }
}