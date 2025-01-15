part of 'home_feed_bloc.dart';

abstract class HomeFeedEvent extends Equatable {
  const HomeFeedEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeFeed extends HomeFeedEvent {
  final GeoPoint userLocation;

  const LoadHomeFeed({required this.userLocation});

  @override
  List<Object> get props => [userLocation];
}

class RefreshHomeFeed extends HomeFeedEvent {
  final GeoPoint userLocation;

  const RefreshHomeFeed({required this.userLocation});

  @override
  List<Object> get props => [userLocation];
}