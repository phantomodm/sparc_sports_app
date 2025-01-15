part of 'home_feed_bloc.dart';

abstract class HomeFeedState extends Equatable {
  const HomeFeedState();

  @override
  List<Object> get props => [];
}

class HomeFeedInitial extends HomeFeedState {}

class HomeFeedLoading extends HomeFeedState {}

class HomeFeedLoaded extends HomeFeedState {
  // TODO Change type
  final List<dynamic> posts;

  const HomeFeedLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class HomeFeedError extends HomeFeedState {
  final String error;

  const HomeFeedError(this.error);

  @override
  List<Object> get props => [error];
}