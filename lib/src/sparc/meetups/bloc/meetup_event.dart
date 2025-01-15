part of 'meetup_bloc.dart';


abstract class MeetupEvent extends Equatable {
  const MeetupEvent();

  @override
  List<Object> get props => [];
}

// In meetup_event.dart
class SearchMeetups extends MeetupEvent {
  final String searchTerm;
  const SearchMeetups(this.searchTerm);
  @override
  List<Object> get props => [searchTerm];
}


class LoadMeetups extends MeetupEvent {
  final String filter; // Add filter property
  final String sort; // Add sort property

  const LoadMeetups({this.filter = 'all', this.sort = 'date'}); // Add constructor

  @override
  List<Object> get props => [filter, sort];
}

class CreateMeetup extends MeetupEvent {
  final Meetup meetup;

  const CreateMeetup(this.meetup);

  @override
  List<Object> get props => [meetup];
}

// ... (other events for updating, deleting, etc.)
