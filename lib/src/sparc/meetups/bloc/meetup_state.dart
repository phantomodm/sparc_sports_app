// meetup_state.dart

//import 'package:equatable/equatable.dart';
part of 'meetup_bloc.dart';

abstract class MeetupState extends Equatable {
  const MeetupState();

  @override
  List<Object> get props => [];
}

class MeetupInitial extends MeetupState {}

class MeetupLoading extends MeetupState {}

class MeetupLoaded extends MeetupState {
  final List<Meetup> meetups;

  const MeetupLoaded(this.meetups);

  @override
  List<Object> get props => [meetups];
}

class MeetupCreated extends MeetupState {}

class MeetupError extends MeetupState {
  final String error;

  const MeetupError(this.error);

  @override
  List<Object> get props => [error];
}

// ... (other states for updating, deleting, etc.)