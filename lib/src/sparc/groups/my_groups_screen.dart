import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/sparc_sports_app.dart';
import 'package:sparc_sports_app/src/core/resources/widgests/filter_widget.dart';
import 'package:sparc_sports_app/src/sparc/groups/bloc/groups_bloc.dart';
import 'package:sparc_sports_app/src/sparc/groups/services/groups_service.dart'; // Import your theme and models

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({Key? key}) : super(key: key);

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  List<Group> _groups = [];
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _groupsPerBatch = 20;
  String _searchText = '';
  List<Group> _allGroups = []; // List to store all fetched groups
  List<Group> _filteredGroups = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchGroups();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // TODO: Load more groups
      _loadMoreGroups();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _loadMoreGroups() async {
    final groups = await GroupService().getGroupsForUser(
      _authService.getCurrentUser()!.uid,
      limit: _groupsPerBatch,
      offset: _currentOffset,
    );
    setState(() {
      _groups.addAll(groups);
      _currentOffset += _groupsPerBatch; // Update the offset
    });
  }

  Future<void> _fetchGroups() async {
    final groups = await GroupService().getGroupsForUser(
      _authService.getCurrentUser()!.uid,
      limit: _groupsPerBatch,
    );
    setState(() {
      _groups = groups;
      _currentOffset = _groupsPerBatch; // Update the offset
    });
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterWidget(
          filterOptions: {
            'Category': ['Category 1', 'Category 2', 'Category 3'],
            'Created By': ['User A', 'User B', 'User C'],
            'Number of Members': ['Any', 'Less than 10', 'Less than 50', 'Less than 100'],
          },
          onFilterChanged: (filters) {
            // TODO: Apply filters to group list
            // 1. Close the modal
            Navigator.pop(context);

            // 2. Apply filters to the group list
            setState(() {
              _filteredGroups = _allGroups.where((group) {
                // Apply category filter
                if (filters['Category'] != null && filters['Category'] != 'All Categories' && group.category != filters['Category']) {
                  return false;
                }
                // Apply "Created By" filter
                if (filters['Created By'] != null && filters['Created By'] != 'All Users' && group.createdBy.userId != filters['Created By']) {
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
          },
        );
      },
    );
  };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsBloc(groupService: GroupService()),
      child: Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterModal(context), // Call _showFilterModal
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search groups...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    // TODO: Update group list based on search text
                    setState(() {
                      _searchText = text;
                    });
                  },
                ),
              ),
            ),
          ]
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state){
          switch (state){
            case GroupsLoading():
              return const Center(child: CircularProgressIndicator());
              case GroupsLoaded():
                _allGroups = state.groups;
                _filteredGroups = state.groups;
                if(state.groups.isEmpty){
                  return const Center(
                  child: Text('You haven\'t joined any groups yet. Create or join a group to connect with others.'),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final group = snapshot.data![index];
                      return Column(
                        children: [
                        _buildGroupCard(group),
                        const SizedBox(height: 8),
                        ],
                      );
                    },
                  );
                }
                case GroupsError():
                  return Center(child: Text('Error: ${state.error}'));
                default:
                  return Container();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to CreateGroupScreen
        },
        child: const Icon(Icons.add),
      ),
    )
   );
  }

  Widget _buildGroupCard(Group group) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(group.groupPhoto), // Assuming Group has a groupPhoto property
        ),
        title: Text(group.name),
        trailing: ElevatedButton(
          onPressed: () {
            // TODO: Navigate to GroupDetailsScreen
          },
          child: const Text('View Details'),
        ),
      ),
    );
  }
}