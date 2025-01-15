// groups_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class GroupsEvent {}

class LoadGroups extends GroupsEvent {
  final String userId;
  final Map<String, dynamic> filters;

  LoadGroups({required this.userId, this.filters = const {}});
}

// States
abstract class GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<Group> groups;

  GroupsLoaded({required this.groups});
}

class GroupsError extends GroupsState {
  final String error;

  GroupsError({required this.error});
}

// Bloc
class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupService _groupService;

  GroupsBloc({required GroupService groupService})
      : _groupService = groupService,
        super(GroupsLoading()) {
    on<LoadGroups>(_onLoadGroups);
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    try {
      List<Group> groups = await _groupService.getGroupsForUser(event.userId);

      // Apply filtering
      groups = _filterGroups(groups, event.filters);

      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupsError(error: e.toString()));
    }
  }

  List<Group> _filterGroups(List<Group> groups, Map<String, dynamic> filters) {
    return groups.where((group) {
      // Apply category filter
      if (filters['Category'] != null &&
          filters['Category'] != 'All Categories' &&
          group.category != filters['Category']) {
        return false;
      }
      // Apply "Created By" filter
      if (filters['Created By'] != null &&
          filters['Created By'] != 'All Users' &&
          group.createdBy.userId != filters['Created By']) {
        return false;
      }
      // Apply "Number of Members" filter
      if (filters['Number of Members'] != null) {
        final memberCount = int.parse(filters['Number of Members']);
        if (group.members.length >= memberCount) {
          return false;
        }
      }
      // Apply keyword filter
      if (filters['keywords'] != null && filters['keywords'].isNotEmpty) {
        final keywords = filters['keywords'].toLowerCase();
        if (!group.name.toLowerCase().contains(keywords) &&
            !group.description.toLowerCase().contains(keywords)) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}