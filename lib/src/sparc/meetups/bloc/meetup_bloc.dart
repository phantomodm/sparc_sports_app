import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparc_sports_app/src/sparc/meetups/models/meetup_models.dart';
import 'package:sparc_sports_app/src/sparc/meetups/services/meetup_service.dart';

part 'meetup_event.dart';
part 'meetup_state.dart';

class MeetupBloc extends Bloc<MeetupEvent, MeetupState> {
  final MeetupService _meetupService;

  MeetupBloc({required MeetupService meetupService})
      : _meetupService = meetupService,
        super(MeetupInitial()) {
    on<LoadMeetups>(_onLoadMeetups);
    on<CreateMeetup>(_onCreateMeetup);
    on<SearchMeetups>(_onSearchMeetups);
    // ... (other event handlers)
  }

  Future<void> _onSearchMeetups(
      SearchMeetups event, Emitter<MeetupState> emit) async {
    emit(MeetupLoading());
    try {
      List<Meetup> meetups = await _meetupService.getMeetups();
      final filteredMeetups = meetups.where((meetup) =>
      meetup.title.toLowerCase().contains(event.searchTerm.toLowerCase()) ||
          meetup.description.toLowerCase().contains(event.searchTerm.toLowerCase()));
      emit(MeetupLoaded(filteredMeetups.toList()));
    } catch (e) {
      emit(MeetupError(e.toString()));
    }
  }

  Future<void> _onLoadMeetups(LoadMeetups event,
      Emitter<MeetupState> emit) async {
    emit(MeetupLoading());
    try {
      List<Meetup> meetups = await _meetupService.getMeetups();
      // Apply filtering
      if (event.filter != 'all') {
        meetups = _filterMeetups(meetups, event.filter);
      }

      // Apply sorting
      meetups = _sortMeetups(meetups, event.sort );
      emit(MeetupLoaded(meetups));
    } catch (e) {
      emit(MeetupError(e.toString()));
    }
  }

  Future<void> _onCreateMeetup(CreateMeetup event,
      Emitter<MeetupState> emit) async {
    emit(MeetupLoading());
    try {
      await _meetupService.createMeetup(event.meetup);
      emit(MeetupCreated());
    } catch (e) {
      emit(MeetupError(e.toString()));
    }
  }

  List<Meetup> _filterMeetups(List<Meetup> meetups, String filter) {
    switch (filter) {
      case 'today':
        return meetups.where((meetup) => _isToday(meetup.date)).toList();
      case 'thisWeek':
        return meetups.where((meetup) => _isThisWeek(meetup.date)).toList();
    // ... add more filter cases
      default:
        return meetups;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return date.isAfter(firstDayOfWeek) && date.isBefore(lastDayOfWeek);
  }

  List<Meetup> _sortMeetups(List<Meetup> meetups, String sort) {
    switch (sort) {
      case 'date':
        meetups.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'popularity':
        meetups.sort((a, b) => b.attendees.length.compareTo(a.attendees.length)); // Sort by attendee count
        break;
    // ... add more sort cases
    }
    return meetups;
  }
}